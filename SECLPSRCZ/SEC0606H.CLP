/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Update Customer Average Prices')             */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                        */
/*                                                                  */
/*       SEC0606H - UPDATE CUSTOMER AVERAGE PRICES                  */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 078453             Date 24Jul96              */
/*                      S01408             Date 11May95              */
/*                      081355                  DATE  09JAN95       */
/*                      S01117                  DATE  08JAN91       */
/*                      S01189                  DATE  08JAN91       */
/*                      E16870                  DATE  08/03/89      */
/*                      E15508                  DATE  02/11/88      */
/*                      S01129                  DATE  05/04/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       078453 - INCLUDE RECOVERY PROCEDURES FOR PRICEA.           */
/*                ADDITIONAL TO FIX 0739748 IN SE2405.              */
/*       S01408 - Addition of core hook SEC0606HMS                  *  *E15549*/
/*       081355 - MISSING CPYF OF CPOSNA                            */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            *  *S01189*/
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                    *  *E16870*/
/*                                                                  */
/********************************************************************/
/************PGM                                                     * *S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
 
/*           DCLDTAARA  DTAARA(SESTAT)                              *  *S01179*/
/*           DCLDTAARA  DTAARA(SDSTAT)                    *  *S01129*  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)      *S01179E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*S01179*/
 
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                * *S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
                                                                      /*S01129*/
/*           RCVDTAARA DTAARA(SDSTAT)                     *  *S01129*  *S01179*/
             RTVDTAARA DTAARA(SDSTAT)  RTNVAR(&SDSTAT)                /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0606HMS                                          */
                                                                      /*S01408*/
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0606H - Update +
                          Customer Average Prices')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* CHECK FOR COMPONENT RESTART                                      */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)           * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF RESTART, COPY FILES                                           */
 
/************IF COND(&BUSY = 'NEW') THEN(DO)                         * *S01189*/
             IF COND(&BUSY = 'Y') THEN(DO)                            /*S01189*/
 
             CPYF       FROMFILE(XCAPRHD) TOFILE(CAPRHD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CAPRHD))
 
             CPYF       FROMFILE(XCAPRHA) TOFILE(CAPRHA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CAPRHA))
 
             CPYF       FROMFILE(XCPOSND) TOFILE(CPOSND) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CPOSND))
 
             CPYF       FROMFILE(XCPOSNA) TOFILE(CPOSNA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE) /* E15508 */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CPOSNA)) /* E15508 */
 
             CPYF       FROMFILE(XPRICED) TOFILE(PRICED) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PRICED))
 
             CPYF       FROMFILE(XPRICEA) TOFILE(PRICEA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*078453*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PRICED))                               /*078453*/
/* CHANGE DATA AREA                     */
 
/***************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
                CHGVAR    VAR(&BUSY) VALUE('N')                       /*S01189*/
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
 
             ENDDO
 
/*  ELSE BACKUP FILES                                               */
 
             ELSE       CMD(DO)
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XCAPRHD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCAPRHA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XPRICED)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XPRICEA)                              /*078453*/
                   MONMSG MSGID(CPF0000)                              /*078453*/
                DLTF       FILE(XCPOSNA)                              /*081355*/
                   MONMSG MSGID(CPF0000)                              /*081355*/
 
/*           CPYF       FROMFILE(CAPRHD) TOFILE(XCAPRHD) +          *  *S01129*/
/*                        MBROPT(*REPLACE) FMTOPT(*NONE)            *  *S01129*/
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +*  *S01129*/
/*                        FILE(XCAPRHD))                            *  *S01129*/
/*                                                                  *  *S01129*/
/*           CPYF       FROMFILE(CAPRHA) TOFILE(XCAPRHA) +          *  *S01129*/
/*                        MBROPT(*REPLACE) FMTOPT(*NONE)            *  *S01129*/
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +*  *S01129*/
/*                        FILE(XCAPRHA))                            *  *S01129*/
/*                                                                  *  *S01129*/
/*           CPYF       FROMFILE(CPOSND) TOFILE(XCPOSND) +          *  *S01129*/
/*                        MBROPT(*REPLACE) FMTOPT(*NONE)            *  *S01129*/
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +*  *S01129*/
/*                        FILE(XCPOSND))                            *  *S01129*/
/*                                                                  *  *S01129*/
/*           CPYF       FROMFILE(PRICED) TOFILE(XPRICED) +          *  *S01129*/
/*                        MBROPT(*REPLACE) FMTOPT(*NONE)            *  *S01129*/
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +*  *S01129*/
/*                        FILE(XPRICED))                            *  *S01129*/
             CPYF       FROMFILE(CAPRHD) TOFILE(&TOLIB/XCAPRHD)  +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01129*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCAPRHD))                              /*S01129*/
                                                                      /*S01129*/
             CPYF       FROMFILE(CAPRHA) TOFILE(&TOLIB/XCAPRHA)  +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01129*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCAPRHA))                              /*S01129*/
                                                                      /*S01129*/
             CPYF       FROMFILE(CPOSND) TOFILE(XCPOSND) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01129*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCPOSND))                              /*S01129*/
                                                                      /*081355*/
             CPYF       FROMFILE(CPOSNA) TOFILE(&TOLIB/XCPOSNA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*081355*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCPOSNA))                              /*081355*/
                                                                      /*081355*/
             CPYF       FROMFILE(PRICED) TOFILE(&TOLIB/XPRICED)  +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01129*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPRICED))                              /*S01129*/
             CPYF       FROMFILE(PRICEA) TOFILE(&TOLIB/XPRICEA)  +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*078453*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPRICEA))                              /*078453*/
 
             ENDDO
 
/*  CHANGE DATA AREA TO 'NEW'                                       */
 
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')            * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* CALL PROGRAM TO EXTRACT TODAY'S CUSTOMER AVERAGE PRICES */
 
                CALL       PGM(SE2405)
 
/*/COPY WNCPYSRC,SEC0606H01                                          */
/* IF NO ERRORS CALL PROGRAM TO UPDATE CUSTOMER AVERAGE PRICES */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CALL       PGM(SE2410)
             ENDDO
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*              RCVDTAARA  DTAARA(LDA)                             */ /* +
S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0606H - Database Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
               CHGVAR    VAR(&MEM) VALUE('SEC0606H - File Controls +
                          Out of Balance')
               SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* NORMAL COMPLETION - CLEAR OUTPUT FILES */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* CHANGE DATA AREA   TO 'OLD'          */
 
/***************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
                CHGVAR    VAR(&BUSY) VALUE('N')                       /*S01189*/
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
 
/*              CLRPFM     FILE(XCAPRHD)                           */ /* +
S01129*/
/*              CLRPFM     FILE(XCAPRHA)                           */ /* +
S01129*/
                CLRPFM     FILE(XCPOSND)
/*              CLRPFM     FILE(XPRICED)                           */ /* +
S01129*/
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XCAPRHD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCAPRHA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XPRICED)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCPOSNA)                              /*081355*/
                   MONMSG MSGID(CPF0000)                              /*081355*/
                DLTF       FILE(XPRICEA)                              /*078453*/
                   MONMSG MSGID(CPF0000)                              /*078453*/
 
                ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
