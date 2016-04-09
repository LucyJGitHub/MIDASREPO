/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Monthly Profitability Report')               */
/*********************************************************************/
/*                                                                   */
/*         Midas - Securities Trading Module                    */
/*                                                                   */
/*       SEC0903 - MONTHLY PROFITABILITY REPORT                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 11MAY95              */
/*       PREV AMEND NO. S01117             DATE 10JAN91              */
/*                      S01189             DATE 10JAN91              */
/*                      E20564             DATE 08DEC89              */
/*                      E20085             DATE 07NOV89              */
/*                      E15714             DATE 03/11/88             */
/*                      S01179             DATE 16/09/88             */
/*                      S01158             DATE 19/05/88             */
/*                      S01129             DATE 05/04/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01408 - Addition of core hook SEC0903MP1                   */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2             */
/*       E20564 - Remove fix E20085 regarding Trade date report.     * *E20564*/
/*       E20085 - Interest and Coupon Calculations Rewrite:          * *E20085*/
/*               - At EOM, automatically produce Trade Date Report.  * *E20085*/
/*               - Eliminated useless tags and declarations.         * *E20085*/
/*       E15714 - Change parameters for SE0920.                      * *E15714*/
/*       S01179 - ABS RELEASE                                        * *S01179*/
/*       S01158 - POST INCORPORATION ERROR FIX.                      * *S01158*/
/*                                                                  */
/********************************************************************/
 
/*           PGM        PARM(&TVTYP)                           */
/*********** PGM                                               */     /*S01158*/
/*                                                             */     /*S01158*/
/************PGM        PARM(&TVTYP &MTH_END)                 *S01158* *S01189*/
/*                                                             */     /*S01158*/
/************PGM        PARM(&TVTYP &MTH_END &CNAM &CSEQ)     *S01189* *S01117*/
             PGM        PARM(&MTH_END &CNAM &CSEQ &RSEQ &RLEV &RENT +
                          &RPARM)                                     /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(SESTAT)                       ********  *S01179*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(SDSTAT)                       ********  *S01179*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
 
             DCL        VAR(&TVTYP)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MTH_END)  TYPE(*CHAR) LEN(1)
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
/************DCL********VAR(&RUNTYP)**TYPE(*CHAR)*LEN(1)***/          /*E20085*/
/************DCL        VAR(&BUSY)  TYPE(*CHAR) LEN(3)               * *S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01117*/
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(1)               /*S01117*/
 
/* EXTRACT PROMPT PARAMETERS FROM RCF */                              /*S01117*/
             CHGVAR     VAR(&OPTION) VALUE(%SST(&RPARM 1 1))          /*S01117*/
/* IF WANT BOTH REPORTS DO THE REPORT FOR TRADE DATE FIRST           * *S01117*/
             IF         COND(&OPTION *EQ 'B') THEN(CHGVAR +
                          VAR(&TVTYP) VALUE('T'))                     /*S01117*/
             ELSE       CMD(CHGVAR VAR(&TVTYP) VALUE(&OPTION))        /*S01117*/
                                                                      /*S01129*/
/* S01179                                                              *S01179*/
/*********   RCVDTAARA  DTAARA(SDSTAT)                      *********  *S01179*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0903MP1                                          */
                                                                      /*S01408*/
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0903 - Monthly +
                          Profitability Report')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/*  CHECK FOR END OF MONTH FLAG                                     */
 
/*********** RTVDTAARA  DTAARA(SESTAT (21 1)) RTNVAR(&RUNTYP)   */    /*S01158*/
             IF         COND(&MTH_END *EQ 'Y') THEN(DO)               /*S01158*/
 
/*******TEMPORARY*PATCH*TO*MAKE*PGM*WORK****/                         /*S01158*/
/*********** CHGVAR     VAR(&TVTYP) VALUE('T')                   */   /*S01158*/
 
/* CHECK FOR COMPONENT RESTART                                   */
 
/************RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)           * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF RESTART, DISABLE ACCESS PATHS                              */
 
/************IF         COND(&BUSY = 'NEW') THEN(DO)                 * *S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
/* AND COPY FILES                                                */
 
                CPYF       FROMFILE(XBKMTHD) TOFILE(BKMTHD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM BKMTHD)
                CPYF       FROMFILE(XBKMTHA) TOFILE(BKMTHA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM BKMTHA)
/* CHANGE DATA AREA TO 'OLD'                                    */
 
/***************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')         * *S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
/**/
 
             ENDDO
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XBKMTHD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XBKMTHA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
 
/* AND COPY FILES                                                */
 
/***********    CPYF       FROMFILE(BKMTHD) TOFILE(XBKMTHD) +       *  *S01129*/
/***********                MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/***********    MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/***********               EXEC(CLRPFM XBKMTHD)                     *  *S01129*/
/***********    CPYF       FROMFILE(BKMTHA) TOFILE(XBKMTHA) +       *  *S01129*/
/***********                MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/***********    MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/***********               EXEC(CLRPFM XBKMTHA)                     *  *S01129*/
             CPYF       FROMFILE(BKMTHD) TOFILE(&TOLIB/XBKMTHD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01129*/
                MONMSG   (CPF2817) CMPDTA(CPF2869) +
                         EXEC(CLRPFM XBKMTHD)                         /*S01129*/
             CPYF       FROMFILE(BKMTHA) TOFILE(&TOLIB/XBKMTHA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01129*/
                MONMSG   (CPF2817) CMPDTA(CPF2869) +
                         EXEC(CLRPFM XBKMTHA)                         /*S01129*/
 
/* CHANGE DATA AREA TO 'NEW'                                    */
 
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')            * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
             ENDDO                                                    /*S01158*/
 
 /* FOLLOWING TAG IS NO LONGER USED */                                /*E20085*/
/*  AGAIN: */                                                         /*E20085*/
AGAIN:                                                                /*S01117*/
 
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* CLEAR FILES */
 
             CLRPFM     FILE(MPREXD)
/*/COPY WNCPYSRC,SEC0903001                                          */
             CLRPFM     FILE(MPREXA)
 
/* CALL MONTHLY PROFITABILITY EXTRACT PROGRAM */
 
/*********** CALL       PGM(SE0920) PARM(&RUNTYP)      */             /*S01158*/
/*********** CALL       PGM(SE0920) PARM(&MTH_END)     */  /*S01158*/ /*E15714*/
             CALL       PGM(SE0920) PARM(&TVTYP &MTH_END)             /*E15714*/
 
/* IF NO ERRORS CALL MONTHLY PROFITABILITY REPORT PROGRAM */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
           IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) THEN(DO) /*S01117*/
             OVRDBF     FILE(MPREX) POSITION(*KEY 1 MPREXDF &RENT)    /*S01117*/
             OPNDBF     FILE(MPREX) OPTION(*ALL)                      /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
               DLTOVR     FILE(MPREX)                                 /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(MPREX)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
           ENDDO                                                      /*S01117*/
 
/*********** CALL       PGM(SE0925) PARM(&TVTYP &RUNTYP)  */          /*S01158*/
/************CALL       PGM(SE0925) PARM(&TVTYP &MTH_END)     *S01158* *S01117*/
             CALL       PGM(SE0925) PARM(&TVTYP &MTH_END &RSEQ &RENT) /*S01117*/
             ENDDO
                                                                      /*E20085*/
/*****If*no*errors*AND*Program*has*been*called*on*a*Value*Date /*E20085 E20564*/
/*****Basis*at*Month-End,*also*produce*a*Trade*Date*Report.*** /*E20085 E20564*/
                                                                      /*E20085*/
/**********  IF ((%SWITCH(XXXXXX00)) *AND (&TVTYP *EQ 'V') +   /*E20085 E20564*/
/**********      *AND (MTH_END *EQ 'Y'))                       /*E20085 E20564*/
/**********     CALL PGM(SE0925) PARM('T' 'Y')                 /*E20085 E20564*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********      RCVDTAARA  DTAARA(LDA)                      *********  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0903 - Database Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO END
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
               CHGVAR    VAR(&MEM) VALUE('SEC0903 - File Controls Out +
                          of Balance')
               SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
               GOTO END
             ENDDO
 
/**************MORE*TEMPORARY*BITS***********/                        /*S01158*/
 
/*********** IF         COND(&TVTYP *EQ 'T') THEN(DO)     */          /*S01158*/
/*********** CHGVAR     VAR(&TVTYP) VALUE('V')            */          /*S01158*/
/*********** GOTO       CMDLBL(AGAIN)                     */          /*S01158*/
/*********** ENDDO                                        */          /*S01158*/
 
/* IF WANT BOTH REPORTS DO THE REPORT FOR VALUE DATE SECOND          * *S01117*/
             IF         COND(&OPTION *EQ 'B' *AND &TVTYP *EQ 'T') +
                          THEN(DO)                                    /*S01117*/
             CHGVAR     VAR(&TVTYP) VALUE('V')                        /*S01117*/
             GOTO       CMDLBL(AGAIN)                                 /*S01117*/
             ENDDO                                                    /*S01117*/
 
/*  IF NO ERRORS CLEAR FILES                                     */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             IF         COND(&MTH_END *EQ 'Y') THEN(DO)               /*S01158*/
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')            * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
             ENDDO                                                    /*S01158*/
 
/*********** CLRPFM     FILE(XBKMTHD)                               *  *S01129*/
/*********** CLRPFM     FILE(XBKMTHA)                               *  *S01129*/
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XBKMTHD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XBKMTHA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
             ENDDO
 
/*END:*********ENDPGM                                                * *S01117*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
