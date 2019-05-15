/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE I/c pay/receive telexes - generation')       */
/*********************************************************************/
/*                                                                   */
/*         Midas - Securities Trading Module                         */
/*                                                                   */
/*    SEC3305 - PAY/RECEIVE TELEXES - INPUT CYCLE PROCESSING         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 10Aug04              */
/* Midas Release 4.01.01 --------------------------------------------*/
/*                      CSW202             Date 20May02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSW025             Date 10Jun02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSE029             Date 19Jul01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      094335             DATE 17JAN96              */
/*                      087779             DATE 25MAY95              */
/*                      S01408             DATE 11MAY95              */
/*                      S01502             DATE 08JUL94              */
/*                      S01401             DATE 16JUN93              */
/*                      E40242             DATE 19JUN92              */
/*                      S01386             DATE 18MAY92              */
/*                      S01117             DATE 11JAN91              */
/*                      S01271             DATE 08JUN90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CSW202 - SWIFT 2002 Standards Update                        */
/*       CSW025 - Midas Message Manager                              */
/*                - New MT566 (ISO15022 message)                     */
/*       CSE029 - ISO15022 messages generation                       */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       094335 - Process all cancellation in a first run.           */
/*       087779 - Prevent duplicate records on MT5xx extract files.  */
/*       S01408 - Addition of core hook SEC3305MP1                   */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*                change in length of SESTAT, 133 long.              */
/*       S01401 - Generate S.W.I.F.T. Settlement Messages if MT5xx   */
/*                Feature switched on.                               */
/*       E40242  -  Produce an audit report for                      */
/*                  S.W.I.F.T. message generation                    */
/*       S01386  -  S.W.I.F.T. Pay/Receives enhancements             */
/*  S01117  -  MULTIBRANCHING                                        */
/*  S01271  -  THIS PROGRAM CREATED FOR IC PAY/RECEIVE MODIFICATION. */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
    PGM
 
/* DECLARATIONS */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/******DCL   VAR(&SESTAT)  TYPE(*CHAR) LEN(128)*/                     /*S01502*/
       DCL   VAR(&SESTAT)  TYPE(*CHAR) LEN(133)                       /*S01502*/
       DCL   VAR(&SDSTAT)  TYPE(*CHAR) LEN(256)
       DCL   VAR(&LDA)     TYPE(*CHAR) LEN(256)
/******DCL   VAR(&MEM)     TYPE(*CHAR) LEN(44)                       * *S01117*/
/******DCL   VAR(&MEM)     TYPE(*CHAR) LEN(50)             /*S01117*/ /*S01401*/
       DCL   VAR(&MEM)     TYPE(*CHAR) LEN(70)                        /*S01401*/
       DCL   VAR(&ICIND)   TYPE(*CHAR) LEN(1)
       DCL   VAR(&PRE)     TYPE(*CHAR) LEN(2)
       DCL   VAR(&TOLIB)   TYPE(*CHAR) LEN(10)
       DCL   VAR(&RSEQ)    TYPE(*CHAR) LEN(5) VALUE('     ')          /*S01117*/
       DCL   VAR(&GROUP)   TYPE(*CHAR) LEN(50)                        /*S01117*/
       DCL   VAR(&USER)    TYPE(*CHAR) LEN(25)                        /*S01117*/
       DCL   VAR(&SLEVEL)  TYPE(*DEC)  LEN(4)                         /*S01117*/
       DCL   VAR(&TIMEO)   TYPE(*DEC)  LEN(5)                         /*S01117*/
       DCL   VAR(&ERRORC)  TYPE(*DEC)  LEN(1) VALUE(0)                /*S01117*/
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1) VALUE(' ')       /*S01386*/
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
       DCL   VAR(&MULT)    TYPE(*CHAR) LEN(2)                         /*S01117*/
       DCL   VAR(&MIDASLG) TYPE(*CHAR) LEN(10)                        /*S01117*/
             DCL (&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')               /*S01401*/
             DCL (&S01401) TYPE(*CHAR) LEN(1) VALUE(' ')              /*S01401*/
             DCL (&CSE029) TYPE(*CHAR) LEN(1) VALUE(' ')              /*CSE029*/
                                                                                          /*CSW202*/
             DCL        VAR(&CSW202) TYPE(*CHAR) LEN(1)                                   /*CSW202*/
                                                                                          /*CSW202*/
/*/COPY WNCPYSRC,SEC3305002                                          */
       DCLF       FILE(SDMMODL0)
 
/******MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)****/ /*S01386*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))                              /*S01386*/
 
/*  MULTIPLE LANGUAGE SUPPORT -                  */                   /*S01117*/
                                                                      /*S01117*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO +
                          &ERRORC &MULT)                              /*S01117*/
                                                                      /*S01117*/
             IF         COND(&MULT *EQ '  ') THEN(DO)                 /*S01117*/
                CHGVAR     VAR(&MULT) VALUE('GB')                     /*S01117*/
             ENDDO                                                    /*S01117*/
                                                                      /*S01117*/
/*  BUILD MULTIPLE LANGUAGE SUPPORT OBJECT NAMES  */                  /*S01117*/
                                                                      /*S01117*/
             CHGVAR     VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')  /*S01117*/
                                                                      /*S01117*/
/*  APPLY MULTIPLE LANGUAGE SUPPORT OVERRIDES  */                     /*S01117*/
                                                                      /*S01117*/
             OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDASLG)                  /*S01117*/
                                                                      /*S01117*/
                                                                      /*S01117*/
       RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
       RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
       CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')             S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC3305MP1                                          */
                                                                      /*S01408*/
 
 
/* SEND PGM MESSAGE */
 
       CHGVAR    VAR(&MEM) VALUE('SEC3305 - I/C Pay/Receive Telexes')
       SNDPGMMSG MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)
             RCVF
/************MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ERROR3))****/ /*S01386*/
 
/*   SET JOB SWITCHES   */
 
             IF         COND((&BGRTBN *EQ 'Y') *OR (&BGIOAC *EQ +
                          'Y')) THEN(CHGJOB SWS(10000000))
       ELSE       CHGJOB     SWS(00000000)
 
 
/*   SET I/C PARAMETER */
 
       CHGVAR VAR(&ICIND) VALUE('I')
 
/****CLEAR*OUTPUT*FILES***/                                           /*S01386*/
 
/******CLRPFM     FILE(CEDCS10)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDCS12)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDCS90)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDCS92)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDCSAC)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDTX31)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDTX32)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDTX41)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDTX42)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDTX51)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDTX52)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDTX61)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDTX62)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDTX81)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDTX82)*************************************/ /*S01386*/
/******CLRPFM     FILE(CEDTXAC)*************************************/ /*S01386*/
/******CLRPFM     FILE(ECASHAB)*************************************/ /*S01386*/
/******CLRPFM     FILE(ECASHAC)*************************************/ /*S01386*/
/******CLRPFM     FILE(NOTLXAB)*************************************/ /*S01386*/
/******CLRPFM     FILE(NOTLXAC)*************************************/ /*S01386*/
/******CLRPFM     FILE(STPR1TX)*************************************/ /*S01386*/
/******CLRPFM     FILE(STPR1ZZ)*************************************/ /*S01386*/
/******CLRPFM     FILE(STPR2TX)*************************************/ /*S01386*/
/******CLRPFM     FILE(STPR2ZZ)*************************************/ /*S01386*/
/******CLRPFM     FILE(STPR3TX)*************************************/ /*S01386*/
/******CLRPFM     FILE(STPR3ZZ)*************************************/ /*S01386*/
/******CLRPFM     FILE(STPR4TX)*************************************/ /*S01386*/
/******CLRPFM     FILE(STPR4ZZ)*************************************/ /*S01386*/
/******CLRPFM     FILE(STPR5TX)*************************************/ /*S01386*/
/******CLRPFM     FILE(STPR5ZZ)*************************************/ /*S01386*/
/******CLRPFM     FILE(UNFORAB)*************************************/ /*S01386*/
/******CLRPFM     FILE(UNFORAC)*************************************/ /*S01386*/
                                                                      /*S01401*/
/*/COPY WNCPYSRC,SEC3305010                                          */
/***  Access Switchable Features file to see if MT5XX present  ***/   /*S01401*/
                                                                      /*S01401*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'S01401')          /*S01401*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&S01401) VALUE('Y'))        /*S01401*/
 
/***  Access Switchable Features file to see if ISO15022 generation   /*CSE029*/
/***  present.  */                                                    /*CSE029*/
                                                                      /*CSE029*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSE029')          /*CSE029*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSE029) VALUE('Y'))        /*CSE029*/
                                                                                          /*CSW202*/
/* Check if SWIFT 2002 is installed */                                                    /*CSW202*/
                                                                                          /*CSW202*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CSW202*/
             CHGVAR     VAR(&CSW202) VALUE('N')                                           /*CSW202*/
             CALL       PGM(SWIF2002) PARM(&PRTCD)                                        /*CSW202*/
             IF         COND(&PRTCD *EQ 'CSW2002') THEN(DO)                               /*CSW202*/
                CHGVAR  VAR(&CSW202) VALUE('Y')                                           /*CSW202*/
             ENDDO                                                                        /*CSW202*/
                                                                      /*CSE029*/
/*   START COMMITMENT CONTROL                               ***/
/****STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))                         /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                  /*CPK009*/
 
/* */                                                                 /*E40242*/
/** Retrieve the system date and time so that the correct          */ /*E40242*/
/** journal entries can be extracted for a SWIFT audit report      */ /*E40242*/
/* */                                                                 /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
                                                                      /*E40242*/
/*****IN THIS SECTION,*EACH*PROGRAM*SHOULD*ONLY*EXECUTE*IF*****/      /*S01386*/
/*****ALL*PREVIOUS*PROGRAMS*HAVE*ENDED*WITHOUT*ERROR,*ELSE*****/      /*S01386*/
/*****PROCESSING*WILL*MOVE*TO*THE*END*OF*THE*SECTION.**********/      /*S01386*/
/* */                                                                 /*S01386*/
/** Restart recovery                                               */ /*S01386*/
/* */                                                                 /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'D') THEN(GOTO TAGD)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'E') THEN(GOTO TAGE)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'F') THEN(GOTO TAGF)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'G') THEN(GOTO TAGG)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'H') THEN(GOTO TAGH)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'I') THEN(GOTO TAGI)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'J') THEN(GOTO TAGJ)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'K') THEN(GOTO TAGK)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'L') THEN(GOTO TAGL)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'M') THEN(GOTO TAGM)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'N') THEN(GOTO TAGN)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'O') THEN(GOTO TAGO)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'P') THEN(GOTO TAGP)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'Q') THEN(GOTO TAGQ)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'R') THEN(GOTO TAGR)      /*S01386*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'S') THEN(GOTO TAGS)      /*S01386*/
/**IF*COND(%SST(&SESTAT*99*1) *EQ 'T') THEN(GOTO TAGT) */  /*S01386*/ /*087779*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'T') THEN(GOTO TAGU)      /*087779*/
             IF COND(%SST(&SESTAT 99 1) *EQ 'U') THEN(GOTO TAGU)      /*S01401*/
/* */                                                                 /*S01386*/
 
/*   PAY/RECEIVE OTHST EXTRACT  */
 TAGD:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(D)                /*S01386*/
       CALL  PGM(SE3310)
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Pay/Receive extract +
                             failure')                                /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   PAY/RECEIVE OTHST EXTRACT  */
 TAGE:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(E)                /*S01386*/
       CALL  PGM(SE3320)
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Pay/Receive extract +
                             failure')                                /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   FORMATTED TELEXES EXTRACT  */
 
 TAGF:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(F)                /*S01386*/
  /*   IF SE0420 FAILED DURING PAY/RECEIVES IN INPUT CYCLE BEFORE */
  /*   THEN USE COPIES OF EUCLID FILES                            */
 
       IF  COND(%SST(&SESTAT 75 1) = 'Y') THEN(DO)
          CPYF    FROMFILE(XSEEUCH) TOFILE(SEEUCH)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCH)
          CPYF    FROMFILE(XSEEUCD0) TOFILE(SEEUCD0)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCD0)
          CPYF    FROMFILE(XSEEUCD1) TOFILE(SEEUCD1)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCD1)
          CPYF    FROMFILE(XSEEUCD2) TOFILE(SEEUCD2)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCD2)
          CPYF    FROMFILE(XSEEUCD3) TOFILE(SEEUCD3)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCD3)
          CPYF    FROMFILE(XSEEUCD4) TOFILE(SEEUCD4)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCD4)
          CPYF    FROMFILE(XSEEUCD5) TOFILE(SEEUCD5)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCD5)
          CPYF    FROMFILE(XSEEUCA) TOFILE(SEEUCA)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCA)
       ENDDO
       ELSE CMD(DO)
          ALCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))
          RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
          CHGVAR     VAR(%SUBSTRING(&SESTAT 75 1)) VALUE('Y')
          CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
          DLCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))
 
 /* IF EUCLID TRANSMISSION FAILED DURING INPUT CYCLE AND WAS NOT   */
 /* REATTEMPTED THEN USE BACK-UP EUCLID TRANSMISSION COPIES.       */
 
          IF COND(%SST(&SESTAT 51 1 ) = '1') THEN(DO)
             CPYF    FROMFILE(SSEUCH) TOFILE(SEEUCH)  +
                     MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM SEEUCH)
             CPYF    FROMFILE(SSEUCD0) TOFILE(SEEUCD0)  +
                     MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM SEEUCD0)
             CPYF    FROMFILE(SSEUCD1) TOFILE(SEEUCD1)  +
                     MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM SEEUCD1)
             CPYF    FROMFILE(SSEUCD2) TOFILE(SEEUCD2)  +
                     MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM SEEUCD2)
             CPYF    FROMFILE(SSEUCD3) TOFILE(SEEUCD3)  +
                     MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM SEEUCD3)
             CPYF    FROMFILE(SSEUCD4) TOFILE(SEEUCD4)  +
                     MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM SEEUCD4)
             CPYF    FROMFILE(SSEUCD5) TOFILE(SEEUCD5)  +
                     MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM SEEUCD5)
             CPYF    FROMFILE(SSEUCA) TOFILE(SEEUCA)  +
                     MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM SEEUCA)
             ALCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
             CHGVAR     VAR(%SUBSTRING(&SESTAT 51 1)) VALUE('0')
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
             DLCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))
          ENDDO
          ELSE CMD(DO)
 
/*  ELSE MAKE BACK-UP COPIES IN CASE OF FAILURE DURING SE0420 */
 
             CPYF    FROMFILE(SEEUCH) TOFILE(&TOLIB/XSEEUCH) +
                     MBROPT(*REPLACE) CRTFILE(*YES) +
                     FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM XSEEUCH)
             CPYF    FROMFILE(SEEUCD0) TOFILE(&TOLIB/XSEEUCD0) +
                     MBROPT(*REPLACE) CRTFILE(*YES) +
                     FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM XSEEUCD0)
             CPYF    FROMFILE(SEEUCD1) TOFILE(&TOLIB/XSEEUCD1) +
                     MBROPT(*REPLACE) CRTFILE(*YES) +
                     FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM XSEEUCD1)
             CPYF    FROMFILE(SEEUCD2) TOFILE(&TOLIB/XSEEUCD2) +
                     MBROPT(*REPLACE) CRTFILE(*YES) +
                     FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM XSEEUCD2)
             CPYF    FROMFILE(SEEUCD3) TOFILE(&TOLIB/XSEEUCD3) +
                     MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM XSEEUCD3)
             CPYF    FROMFILE(SEEUCD4) TOFILE(&TOLIB/XSEEUCD4) +
                     MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM XSEEUCD4)
             CPYF    FROMFILE(SEEUCD5) TOFILE(&TOLIB/XSEEUCD5) +
                     MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM XSEEUCD5)
             CPYF    FROMFILE(SEEUCA) TOFILE(&TOLIB/XSEEUCA) +
                     MBROPT(*REPLACE) CRTFILE(*YES) +
                     FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                     EXEC(CLRPFM XSEEUCA)
          ENDDO
       ENDDO
 
/**/                                                                  /*S01386*/
/*   Clear output files                                            */ /*S01386*/
/**/                                                                  /*S01386*/
                                                                      /*S01386*/
       CLRPFM     FILE(CEDCS10)                                       /*S01386*/
       CLRPFM     FILE(CEDCS12)                                       /*S01386*/
       CLRPFM     FILE(CEDCS90)                                       /*S01386*/
       CLRPFM     FILE(CEDCS92)                                       /*S01386*/
       CLRPFM     FILE(CEDCSAC)                                       /*S01386*/
       CLRPFM     FILE(CEDTX31)                                       /*S01386*/
       CLRPFM     FILE(CEDTX32)                                       /*S01386*/
       CLRPFM     FILE(CEDTX41)                                       /*S01386*/
       CLRPFM     FILE(CEDTX42)                                       /*S01386*/
       CLRPFM     FILE(CEDTX51)                                       /*S01386*/
       CLRPFM     FILE(CEDTX52)                                       /*S01386*/
       CLRPFM     FILE(CEDTX61)                                       /*S01386*/
       CLRPFM     FILE(CEDTX62)                                       /*S01386*/
       CLRPFM     FILE(CEDTX81)                                       /*S01386*/
       CLRPFM     FILE(CEDTX82)                                       /*S01386*/
       CLRPFM     FILE(CEDTXAC)                                       /*S01386*/
       CLRPFM     FILE(ECASHAB)                                       /*S01386*/
       CLRPFM     FILE(ECASHAC)                                       /*S01386*/
       CLRPFM     FILE(NOTLXAB)                                       /*S01386*/
       CLRPFM     FILE(NOTLXAC)                                       /*S01386*/
       CLRPFM     FILE(STPR1TX)                                       /*S01386*/
       CLRPFM     FILE(STPR1ZZ)                                       /*S01386*/
       CLRPFM     FILE(STPR2TX)                                       /*S01386*/
       CLRPFM     FILE(STPR2ZZ)                                       /*S01386*/
       CLRPFM     FILE(STPR3TX)                                       /*S01386*/
       CLRPFM     FILE(STPR3ZZ)                                       /*S01386*/
       CLRPFM     FILE(STPR4TX)                                       /*S01386*/
       CLRPFM     FILE(STPR4ZZ)                                       /*S01386*/
       CLRPFM     FILE(STPR5TX)                                       /*S01386*/
       CLRPFM     FILE(STPR5ZZ)                                       /*S01386*/
       CLRPFM     FILE(UNFORAB)                                       /*S01386*/
       CLRPFM     FILE(UNFORAC)                                       /*S01386*/
/*/COPY WNCPYSRC,SEC3305012                                          */
                                                                      /*S01386*/
/******CALL  PGM(SE0420)   PARM(&ICIND)                              * *S01117*/
       CALL  PGM(SE0420)   PARM(&ICIND &RSEQ)                         /*S01117*/
/******IF    COND(%SWITCH(XXXXXXX1)) THEN(DO)***********************/ /*S01386*/
/*********GOTO CMDLBL(ERROR1)***************************************/ /*S01386*/
/******ENDDO********************************************************/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Pay/Receive file +
                             split failure')                          /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   UNFORMATTED TELEXES EXTRACT  */
 TAGG:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(G)                /*S01386*/
       CALL       PGM(SE0421) PARM(&BGSWST &BGMTMI  +
                           &ICIND)
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Pay/Receive telex +
                             extract failure')                        /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   SET EUCLID LINES NUMBERS     */
/******CALL  PGM(SE0425) PARM(&ICIND)                                * *S01117*/
/*/COPY WNCPYSRC,SEC3305013                                          */
 TAGH:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(H)                /*S01386*/
       CALL  PGM(SE0425) PARM(&ICIND &RSEQ)                           /*S01117*/
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Set EUCLID line +
                             number failure')                         /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   EUROCLEAR INSTRUCTIONS */
 TAGI:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(I)                /*S01386*/
       CHGJOB SWS(XXXXX1XX)
/******CALL  PGM(SE0430) PARM(&ICIND)                                * *S01117*/
       CALL  PGM(SE0430) PARM(&ICIND &RSEQ)                           /*S01117*/
       CHGJOB SWS(XXXXX0XX)
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Euroclear +
                             instructions failure')                   /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   EUROCLEAR CASH  */
 TAGJ:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(J)                /*S01386*/
/******CALL PGM(SE0440) PARM(&ICIND)                                 * *S01117*/
       CALL PGM(SE0440) PARM(&ICIND &RSEQ)                            /*S01117*/
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Euroclear cash +
                             telexes failure')                        /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   CEDEL INSTRUCTIONS  */
 TAGK:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(K)                /*S01386*/
/******CALL PGM(SE0450) PARM(&ICIND)                                 * *S01117*/
       CALL PGM(SE0450) PARM(&ICIND &RSEQ)                            /*S01117*/
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('CEDEL telex +
                             instructions failure')                   /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   CEDEL CASH  */
 TAGL:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(L)                /*S01386*/
/******CALL PGM(SE0460) PARM(&ICIND)                                 * *S01117*/
       CALL PGM(SE0460) PARM(&ICIND &RSEQ)                            /*S01117*/
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('CEDEL cash +
                             telexes failure')                        /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   COMPLETE TELEXES  */
 TAGM:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(M)                /*S01386*/
/******CALL PGM(SE0470) PARM(&ICIND)                                 * *S01117*/
       CALL PGM(SE0470) PARM(&ICIND &RSEQ)                            /*S01117*/
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Pay/Receive +
                             telexes formatting failure')             /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   INCOMPLETE TELEXES  */
 TAGN:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(N)                /*S01386*/
/******CALL PGM(SE0480) PARM(&ICIND)                                 * *S01117*/
       CALL PGM(SE0480) PARM(&ICIND &RSEQ)                            /*S01117*/
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Incomplete +
                             telexes formatting failure')             /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   OTHER SETTLEMENT INSTRUCTIONS  */
 TAGO:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(O)                /*S01386*/
/******CALL PGM(SE0486) PARM(&ICIND)                                 * *S01117*/
       CALL PGM(SE0486) PARM(&ICIND &RSEQ)                            /*S01117*/
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Other settlements +
                             report failure')                         /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   BANKERS AUTHORISATIONS  */
 TAGP:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(P)                /*S01386*/
/******CALL PGM(SE0490) PARM(&ICIND)                                 * *S01117*/
       CALL PGM(SE0490) PARM(&ICIND &RSEQ)                            /*S01117*/
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Bankers +
                             Authorisations failure')                 /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   INTERNAL SETTLEMENTS  */
 TAGQ:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(Q)                /*S01386*/
/******CALL PGM(SE0500) PARM(&ICIND)                                 * *S01117*/
       CALL PGM(SE0500) PARM(&ICIND &RSEQ)                            /*S01117*/
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Internal settlements +
                             failure')                                /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   TRADES NO. TELEXES  */
 TAGR:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(R)                /*S01386*/
/******CALL PGM(SE0510) PARM(&ICIND)                                 * *S01117*/
       CALL PGM(SE0510) PARM(&ICIND &RSEQ)                            /*S01117*/
/******IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR1))*****/ /*S01386*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Trades with no Telex +
                             failure')                                /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
 
/*   SWIFT SETTLEMENTS - IF SE SWIFT IS INSTALLED */
 
 TAGS:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(S)                /*S01386*/
       IF         COND(&BGSWST *EQ 'Y') +
       THEN(DO)
 
          CHGDTAARA DTAARA(LDA) VALUE(' ')
/*********OVRDBF    FILE(TABMS) SHARE(*NO)                           * *S01117*/
 
/*********CALL PGM(SE1810) PARM(&ICIND)                              * *S01117*/
                                                                      /*S01386*/
             OVRDBF     FILE(TRADS) SHARE(*NO)                        /*S01386*/
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)                     /*S01386*/
/*/COPY WNCPYSRC,SEC3305006                                          */
             CALL       PGM(SE1710)                                   /*S01386*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Pay/Receive message +
                             generation failure')                     /*S01386*/
                  CLRPFM     FILE(MGF100PD)                           /*S01386*/
                  CLRPFM     FILE(MGF202PD)                           /*S01386*/
                  CLRPFM     FILE(MGF210PD)                           /*S01386*/
/*/COPY WNCPYSRC,SEC3305007                                          */
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
/* */                                                                 /*S01386*/
/** Process the GDF's                                              */ /*S01386*/
/* */                                                                 /*S01386*/
      TAGT:       CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(T)           /*S01386*/
                                                                      /*S01401*/
/***  If the MT5XX Feature is present, then extract and  ***/         /*S01401*/
/***  generate the S.W.I.F.T. Settlement Messages.       ***/         /*S01401*/
                                                                      /*S01401*/
             IF (&S01401 *EQ 'Y') THEN(DO)                            /*S01401*/
                                                                      /*S01401*/
               OVRDBF (MGOREFL0) SHARE(*NO)                           /*S01401*/
                                                                      /*S01401*/
/***  Extract Trade Settlement Messages.  ***/                        /*S01401*/
                                                                      /*S01401*/
               CALL (SE1871) PARM(&RSEQ)                              /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 CHGVAR (&MEM) VALUE('SE1871 - Trades Extract for +
                    S.W.I.F.T. Settlements failed.')                  /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
/***  Extract Depot Movement Settlement Messages.  ***/               /*S01401*/
                                                                      /*S01401*/
               CALL (SE1873) PARM('N' &RSEQ)                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 CHGVAR (&MEM) VALUE('SE1873 - Depot Movements +
                    Extract for S.W.I.F.T. Settlements failed.')      /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
/***  Extract Position Settlement Messages.  ***/                     /*S01401*/
                                                                      /*S01401*/
               CALL PGM(SE1874) PARM(&RSEQ)                           /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 CHGVAR (&MEM) VALUE('SE1874 - Position Settlements +
                    Extract for S.W.I.F.T. Settlements failed.')      /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
               DLTOVR (MGOREFL0)                                      /*S01401*/
                                                                      /*S01401*/
/*/COPY WNCPYSRC,SEC3305003                                          */
             ENDDO                                                    /*S01401*/
 
 TAGU:       CHGDTAARA (SESTAT (99 1)) VALUE(U)                       /*S01401*/
/*/COPY WNCPYSRC,SEC3305001                                          */
/* */                                                                 /*S01386*/
/** Customer transfers                                             */ /*S01386*/
/* */                                                                 /*S01386*/
             CALL       PGM(MG0100)                                   /*S01386*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  SNDPGMMSG  MSG('Customer transfer formatting +
                               failure') TOPGMQ(*EXT) TOMSGQ(MOPERQ)  /*S01386*/
                  IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)         /*S01386*/
                       ROLLBACK                                       /*S01386*/
                  ENDDO                                               /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
/* */                                                                 /*S01386*/
/** Bank transfers                                                 */ /*S01386*/
/* */                                                                 /*S01386*/
             CALL       PGM(MG0202)                                   /*S01386*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  SNDPGMMSG  MSG('Bank transfer formatting +
                               failure') TOPGMQ(*EXT) TOMSGQ(MOPERQ)  /*S01386*/
                  IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)         /*S01386*/
                       ROLLBACK                                       /*S01386*/
                  ENDDO                                               /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
/* */                                                                 /*S01386*/
/** Notice to receives                                             */ /*S01386*/
/* */                                                                 /*S01386*/
             CALL       PGM(MG0210)                                   /*S01386*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  SNDPGMMSG  MSG('Notice to receive formatting +
                               failure') TOPGMQ(*EXT) TOMSGQ(MOPERQ)  /*S01386*/
                  IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)         /*S01386*/
                       ROLLBACK                                       /*S01386*/
                  ENDDO                                               /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
/*/COPY WNCPYSRC,SEC3305011                                          */
                                                                      /*S01401*/
/***  If MT5XX Feature present then process S.W.I.F.T. Settlements */ /*S01401*/
                                                                      /*S01401*/
             IF (&S01401 *EQ 'Y') THEN(DO)                            /*S01401*/
                                                                      /*S01401*/
/*** If CSE029 ISO15022 is present then process data download ***  */ /*CSE029*/
/* */                                                                 /*CSE029*/
             IF (&CSE029 *EQ 'Y') THEN(DO)                            /*CSE029*/
             CALL MXC0710 PARM('MSG_TRD' 'C' '*NONE')                 /*CSE029*/
             CALL MXC0720 PARM('MSG_TRD' 'C' '*NONE')                 /*CSE029*/
             CALL MXC0710 PARM('MSG_DPM' 'C' '*NONE')                 /*CSE029*/
             CALL MXC0720 PARM('MSG_DPM' 'C' '*NONE')                 /*CSE029*/
             CALL MXC0710 PARM('MSG_PST' 'C' '*NONE')                                     /*CSW025*/
             CALL MXC0720 PARM('MSG_PST' 'C' '*NONE')                                     /*CSW025*/
             IF (%SWITCH(XXXXXX11)) THEN(DO)                          /*CSE029*/
                 SNDPGMMSG  MSG('ISO15022 Data Extract failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*CSE029*/
                 GOTO (ERROR)                                         /*CSE029*/
             ENDDO                                                    /*CSE029*/
             CALL SE1879
             IF (%SWITCH(XXXXXX11)) THEN(DO)                          /*CSE029*/
                 SNDPGMMSG  MSG('ISO15022 Status update failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*CSE029*/
                 GOTO (ERROR)                                         /*CSE029*/
             ENDDO
             ENDDO
                                                                                          /*CSW202*/
/* If SWIFT2002 is installed. bypass generation of    */                                  /*CSW202*/
/* MT520, MT521, MT522, MT523 and MT580 messages.     */                                  /*CSW202*/
                                                                                          /*CSW202*/
             IF         COND(&CSW202 *EQ 'Y') THEN(GOTO SW2002)                           /*CSW202*/
                                                                      /*094335*/
             OVRDBF     FILE(MGF580L0) TOFILE(MGF580L1)               /*094335*/
             CALL       PGM(MG0580)                                   /*094335*/
             DLTOVR     FILE(MGF580L0)                                /*094335*/
     IF COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) THEN(CHGVAR -
VAR(&MEM) VALUE('SEC0603/MG0580 MT5xx Settlements extract failure'))  /*094335*/
     IF COND(%SWITCH(XXXXXXX1)) THEN(GOTO CMDLBL(ERROR))              /*094335*/
                                                                      /*094335*/
/***  MT520 - Receive Free Messages.  ***/                            /*S01401*/
                                                                      /*S01401*/
               CALL (MG0520)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 SNDPGMMSG ('MG0520 - Receive Free +
                    Message Formatting failure') TOPGMQ(*EXT) +
                    TOMSGQ(MOPERQ)                                    /*S01401*/
                 ROLLBACK                                             /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
/***  MT521 - Receive Against Payment Messages.  ***/                 /*S01401*/
                                                                      /*S01401*/
               CALL (MG0521)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 SNDPGMMSG ('MG0521 - Receive Against Payment +
                    Message Formatting failure') TOPGMQ(*EXT) +
                    TOMSGQ(MOPERQ)                                    /*S01401*/
                 ROLLBACK                                             /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
/***  MT522 - Deliver Free Messages.  ***/                            /*S01401*/
                                                                      /*S01401*/
               CALL (MG0522)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 SNDPGMMSG ('MG0522 - Deliver Free +
                    Message Formatting failure') TOPGMQ(*EXT) +
                    TOMSGQ(MOPERQ)                                    /*S01401*/
                 ROLLBACK                                             /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
/***  MT523 - Deliver Against Payment Messages.  ***/                 /*S01401*/
                                                                      /*S01401*/
               CALL (MG0523)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 SNDPGMMSG ('MG0523 - Deliver Against Payment +
                    Message Formatting failure') TOPGMQ(*EXT) +
                    TOMSGQ(MOPERQ)                                    /*S01401*/
                 ROLLBACK                                             /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
/***  MT579/MT580 - Instructions to Clearing System Messages.  ***/   /*S01401*/
                                                                      /*S01401*/
               OVRDBF (MGF579PD) SHARE(*NO)                           /*S01401*/
               CALL (MG0580)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 SNDPGMMSG ('MG0580 - Instructions to Clearing +
                    System Message Formatting failure') +
                    TOPGMQ(*EXT) TOMSGQ(MOPERQ)                       /*S01401*/
                 ROLLBACK                                             /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
               DLTOVR (MGF579PD)                                      /*S01401*/
                                                                                          /*CSW202*/
SW2002:                                                                                   /*CSW202*/
                                                                      /*S01401*/
/***  MT554 - Advice of Money Income Messages.  ***/                  /*S01401*/
                                                                      /*S01401*/
               CALL (MG0554)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 SNDPGMMSG ('MG0554 - Advice of Money Income +
                    Message Formatting failure') TOPGMQ(*EXT) +
                    TOMSGQ(MOPERQ)                                    /*S01401*/
                 ROLLBACK                                             /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
/*/COPY WNCPYSRC,SEC3305004                                          */
/***  End of MT5XX S.W.I.F.T. Messages Generation.  ***/              /*S01401*/
             ENDDO                                                    /*S01401*/
                                                                      /*S01386*/
/**********  RGZPFM     FILE(MGF100PD)                                /*S01386*/          /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                        /*S01386*/          /*228542*/
             CALL       PGM(SCC000060) PARM('MGF100PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGF202PD)                                /*S01386*/          /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                        /*S01386*/          /*228542*/
             CALL       PGM(SCC000060) PARM('MGF202PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGF210PD)                                /*S01386*/          /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                        /*S01386*/          /*228542*/
             CALL       PGM(SCC000060) PARM('MGF210PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/*/COPY WNCPYSRC,SEC3305008                                          */
/**********  RGZPFM (MGF520PD)                                        /*S01401*/          /*228542*/
/**********  MONMSG (CPF2995 CPF2981)                                 /*S01401*/          /*228542*/
             CALL       PGM(SCC000060) PARM('MGF520PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM (MGF521PD)                                        /*S01401*/          /*228542*/
/**********  MONMSG (CPF2995 CPF2981)                                 /*S01401*/          /*228542*/
             CALL       PGM(SCC000060) PARM('MGF521PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM (MGF522PD)                                        /*S01401*/          /*228542*/
/**********  MONMSG (CPF2995 CPF2981)                                 /*S01401*/          /*228542*/
             CALL       PGM(SCC000060) PARM('MGF522PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM (MGF523PD)                                        /*S01401*/          /*228542*/
/**********  MONMSG (CPF2995 CPF2981)                                 /*S01401*/          /*228542*/
             CALL       PGM(SCC000060) PARM('MGF523PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM (MGF580PD)                                        /*S01401*/          /*228542*/
/**********  MONMSG (CPF2995 CPF2981)                                 /*S01401*/          /*228542*/
             CALL       PGM(SCC000060) PARM('MGF580PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM (MGF554PD)                                        /*S01401*/          /*228542*/
/**********  MONMSG (CPF2995 CPF2981)                                 /*S01401*/          /*228542*/
             CALL       PGM(SCC000060) PARM('MGF554PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM (MGISOTPD)                                        /*CSE029*/          /*228542*/
/**********  MONMSG (CPF2995 CPF2981)                                 /*CSE029*/          /*228542*/
             CALL       PGM(SCC000060) PARM('MGISOTPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM (MGISODPD)                                        /*CSE029*/          /*228542*/
/**********  MONMSG (CPF2995 CPF2981)                                 /*CSE029*/          /*228542*/
             CALL       PGM(SCC000060) PARM('MGISODPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM (MGISOPPD)                                                 /*CSW025*/ /*228542*/
/**********  MONMSG (CPF2995 CPF2981)                                          /*CSW025*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGISOPPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/*/COPY WNCPYSRC,SEC3305005                                          */
                                                                      /*S01386*/
/* */                                                                 /*E40242*/
/** Produce an audit report.                                       */ /*E40242*/
/** The parameters are: Module, Type of run, Journal, Date, Time   */ /*E40242*/
/* */                                                                 /*E40242*/
             CALL       PGM(MEC0890) PARM('SE' 'P' 'ICJRN     ' +
                          &SDATE &STIME)                              /*E40242*/
                                                                      /*E40242*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*E40242*/
                  CHGVAR     VAR(&MEM) VALUE('Audit report failure')  /*E40242*/
                  GOTO       CMDLBL(ERROR)                            /*E40242*/
             ENDDO                                                    /*E40242*/
/*/COPY WNCPYSRC,SEC3305009                                          */
 
 
       ENDDO                                                          /*S01386*/
 
/*********MONMSG    MSGID(CPF0000 RPG0000 MCH0000) +      **********/ /*S01386*/
/*********EXEC(DO)                                        **********/ /*S01386*/
 
/**********  ROLLBACK                                     **********/ /*S01386*/
/**********  CHGJOB     SWS(XXXXX1XX)                     **********/ /*S01386*/
/**********  SNDPGMMSG  ('TRANSACTION FAILED. RE-INPUT +  **********/ /*S01386*/
/**********               NECESSARY. ENTER TO CONTINUE.') +*********/ /*S01386*/
/**********             TOMSGQ(MOPERQ)                    **********/ /*S01386*/
/*********ENDDO                                           **********/ /*S01386*/
/**********                                               **********/ /*S01386*/
/*********IF  COND(%SWITCH(XXXXXX01)) THEN( +             **********/ /*S01386*/
/**********  SNDPGMMSG  ('FILE CONTROLS OUT OF BALANCE') +**********/ /*S01386*/
/**********             TOMSGQ(MRUNQ MOPERQ))             **********/ /*S01386*/
/**********                                               **********/ /*S01386*/
/*********IF  COND(%SWITCH(XXXXXX11)) THEN(DO)            **********/ /*S01386*/
/**********                                               **********/ /*S01386*/
/**********  RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)          **********/ /*S01386*/
/************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))****/ /*S01386*/
/**                                                        /*S01117*/ /*S01386*/
/**********  CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))****/ /*S01386*/
/**                                                        /*S01117*/ /*S01386*/
/**********  SNDPGMMSG  MSGID(MEM0091) MSGF(MIDAS) MSGDTA(&MEM)*+***/ /*S01386*/
/**********             TOMSGQ(MOPERQ MRUNDQ)             **********/ /*S01386*/
/**********  ROLLBACK                                     **********/ /*S01386*/
/**********                                               **********/ /*S01386*/
/*********ENDDO                                           **********/ /*S01386*/
 
/*********ENDCMTCTL*************************************************/ /*S01386*/
/*********DLTOVR    FILE(TABMS)                                      * *S01117*/
/******ENDDO                                              **********/ /*S01386*/
 
/****TELEX*CONVERSION***/                                             /*S01386*/
/* */                                                                 /*S01386*/
/******IF COND(&BGMTMI *EQ 'Y') THEN(CALL PGM(MTC0010))*************/ /*S01386*/
 
/*   CLEAR OUTPUT FILES  */
       IF  COND(%SWITCH(XXXXXX00)) THEN(DO)
          ALCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))
          RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
          CHGVAR     VAR(%SUBSTRING(&SESTAT 75 1)) VALUE('N')
          CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
          DLCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))
          CLRPFM     FILE(CEDCS10)
          CLRPFM     FILE(CEDCS12)
          CLRPFM     FILE(CEDCS90)
          CLRPFM     FILE(CEDCS92)
          CLRPFM     FILE(CEDCSAC)
          CLRPFM     FILE(CEDTX31)
          CLRPFM     FILE(CEDTX32)
          CLRPFM     FILE(CEDTX41)
          CLRPFM     FILE(CEDTX42)
          CLRPFM     FILE(CEDTX51)
          CLRPFM     FILE(CEDTX52)
          CLRPFM     FILE(CEDTX61)
          CLRPFM     FILE(CEDTX62)
          CLRPFM     FILE(CEDTX81)
          CLRPFM     FILE(CEDTX82)
          CLRPFM     FILE(CEDTXAC)
          CLRPFM     FILE(ECASHAB)
          CLRPFM     FILE(ECASHAC)
          CLRPFM     FILE(NOTLXAB)
          CLRPFM     FILE(NOTLXAC)
          CLRPFM     FILE(STPR1TX)
          CLRPFM     FILE(STPR1ZZ)
          CLRPFM     FILE(STPR2TX)
          CLRPFM     FILE(STPR2ZZ)
          CLRPFM     FILE(STPR3TX)
          CLRPFM     FILE(STPR3ZZ)
          CLRPFM     FILE(STPR4TX)
          CLRPFM     FILE(STPR4ZZ)
          CLRPFM     FILE(STPR5TX)
          CLRPFM     FILE(STPR5ZZ)
          CLRPFM     FILE(UNFORAB)
          CLRPFM     FILE(UNFORAC)
          CLRPFM     FILE(SETLXD)
          CLRPFM     FILE(SETLXA)
          CLRPFM     FILE(OTHSTD)
          CLRPFM     FILE(OTHSTA)
          DLTF       FILE(XSEEUCH)
          MONMSG MSGID(CPF0000)
          DLTF       FILE(XSEEUCD0)
          MONMSG MSGID(CPF0000)
          DLTF       FILE(XSEEUCD1)
          MONMSG MSGID(CPF0000)
          DLTF       FILE(XSEEUCD2)
          MONMSG MSGID(CPF0000)
          DLTF       FILE(XSEEUCD3)
          MONMSG MSGID(CPF0000)
          DLTF       FILE(XSEEUCD4)
          MONMSG MSGID(CPF0000)
          DLTF       FILE(XSEEUCD5)
          MONMSG MSGID(CPF0000)
          DLTF       FILE(XSEEUCA)
          MONMSG MSGID(CPF0000)
        ENDDO
 
/* */
/** Indicate that no error has occurred                            */ /*S01386*/
/* */                                                                 /*S01386*/
             CHGDTAARA  DTAARA(SESTAT (99 1)) VALUE(' ')              /*S01386*/
             CHGVAR     VAR(&ERR) VALUE('N')                          /*S01386*/
                                                                      /*S01386*/
             GOTO       CMDLBL(ENDPGM)                                /*S01386*/
                                                                      /*S01386*/
 ERROR:      IF         COND(&MEM *EQ ' ') THEN(DO)                   /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Pay/receive +
                               generation failure')                   /*S01386*/
             ENDDO                                                    /*S01386*/
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)         /*S01386*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01386*/
/* */                                                                 /*S01386*/
/** Indicate that there has been an error                          */ /*S01386*/
/* */                                                                 /*S01386*/
             CHGVAR     VAR(&ERR) VALUE('Y')                          /*S01386*/
/* */                                                                 /*S01386*/
/* DATABASE IN ERROR */
 
ERROR1: IF           COND(%SWITCH(XXXXXX11)) THEN(DO)
          RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01386*/
/*********CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))        * *S01117*/
          CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))         /*S01117*/
/*********SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                     TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)**************/ /*S01386*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*S01386*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01386*/
/*********CHGVAR     VAR(&MEM) VALUE('SEC3305 - Job Terminated, +
                                      Database in Error')***********/ /*S01386*/
/*********SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)****/ /*S01386*/
       ENDDO
                                                                      /*S01386*/
             CHGJOB     SWS(XXXXXX11)                                 /*S01386*/
 
/**FILE*CONTROLS*OUT*OF*BALANCE**/
 
/******IF  COND(%SWITCH(XXXXXX01)) THEN(DO)*************************/ /*S01386*/
/*********CHGVAR    VAR(&MEM) VALUE('SEC3305 - File Controls out +
                                     of Balance')*******************/ /*S01386*/
/*********SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)  **/ /*S01386*/
/******ENDDO                                                      **/ /*S01386*/
 
/*********   GOTO ENDPGM                                          **/ /*S01386*/
/************************************************************/        /*S01386*/
/*ERROR3:     SNDPGMMSG  MSG('Program SEC3305 ended abnormally - +
                          SDMMODL0 in error.') TOPGMQ(*EXT) +
                          TOMSGQ(MRUNQ MOPERQ)**********************/ /*S01386*/
/*********   GOTO ENDPGM                                          **/ /*S01386*/
/************************************************************/        /*S01386*/
/*ABNORMAL:   SNDPGMMSG  MSG('SEC3305 - Pay/Receive reporting +*****/ /*S01386*/
/**********ended abnormally') TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)*****/ /*S01386*/
/***************MONMSG     MSGID(CPF2400)***************************/ /*S01386*/
                                                                      /*S01386*/
ENDPGM:
 
/*   INDICATE PAY/RECEIVE PRINT IS FINISHED */
 
                CHGDTAARA  DTAARA(SESTAT (74 1)) VALUE('N')
                MONMSG     MSGID(CPF1000)
 
             ENDCMTCTL                                                /*S01386*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01386*/
/* */                                                                 /*S01386*/
/** Report that the Pay/Receive run has completed                  */ /*S01386*/
/* */                                                                 /*S01386*/
             IF         COND(&ERR *EQ 'Y') THEN(CHGVAR VAR(&MEM) +
                          VALUE('Securities Pay/Receive run +
                          completed abnormally'))                     /*S01386*/
 
             IF         COND(&ERR *EQ 'N') THEN(CHGVAR VAR(&MEM) +
                          VALUE('Securities Trading Pay/Receive run +
                          was successful'))                           /*S01386*/
 
             IF         COND(&ERR *NE ' ') THEN(DO)                   /*S01386*/
                  SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                               MRUNQ)                                 /*S01386*/
                  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)           /*S01386*/
             ENDDO                                                    /*S01386*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
    ENDPGM
