/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Generate A/c Keys - Trades')                 */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0602C  GENERATE A/C KEYS - TRADES                       */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CSE017             Date 20Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 10May95              */
/*                      E34903             Date 04Feb92              */
/*                      E29028        DATE 01OCT91                  */
/*                      S01117        DATE 07JAN91                  */
/*                      S01189        DATE 07/04/89                 */
/*                      E16870        DATE 08/03/89                 */
/*                      S01176        DATE 26/07/88                 */
/*                      S01129        DATE 31/03/88                 */
/*                                                                  */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompile)    */
/*  S01408 - Addition of core hook SEC0602CMS                       */
/*  E34903 - PAY/RECEIVE IN INPUT CYCLE - DO NOT CLEAR OTHSTD AND   */
/*           SETLXD FILES AS THESE MAY CONTAIN DATA FROM FAILED I/C */
/*           PAY/RECEIVE RUN.  N.B. SE2290 NO LONGER EXTRACTS DATA  */
/*           TO OTHSTD - THIS IS DONE BY SE3315                     */
/*  E29028 - DO NOT REMOVE MEMBER OF TRADS AS NOW USED IN SE2290    */
/*  S01117 - MULTIBRANCHING                                         */
/*  E16870 - SESTAT REDEFINED AS 128 BYTES.                         *  *E16870*/
/*  S01176 - SECURITIES TRADING 3.1 (AUSTRALIA)                     *  *S01176*/
/*                                                                   */
/********************************************************************/
/********    PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
/********    DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 /*S01189*/
/*           DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)             */ /*S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
/*/COPY WNCPYSRC,SEC0602C05                                          */
 
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/*           DCLDTAARA  DTAARA(SESTAT)                              *  *S01179*/
/*           DCLDTAARA  DTAARA(SDSTAT)                    *  *S01129*  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)     /*S01179E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*S01179*/
                MONMSG MSGID(CPF2817)                                 /*S01129*/
                                                                      /*S01129*/
/*           RCVDTAARA DTAARA(SDSTAT)                     *  *S01129*  *S01179*/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)                 /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0602CMS                                          */
                                                                      /*S01408*/
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
 
             CHGVAR     VAR(&MSG) VALUE('SEC0602C - GENERATE A/C KEYS +
                          - TRADES')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* SET OFF SWITCHES                                              */
 
 
             CHGJOB     SWS(00000000)
 
/* CLEAR OUTPUT FILES                                            */
 
 
             CLRPFM     FILE(TRDACD) MBR(TRDACD)
             CLRPFM     FILE(TRDACA) MBR(TRDACA)
             CLRPFM     FILE(SEKEYD) MBR(TRADE)
             CLRPFM     FILE(SEKEYA) MBR(TRADE)
/************CLRPFM     FILE(SETLXD) MBR(SETLXD)                     * *E34903*/
/************CLRPFM     FILE(SETLXA) MBR(SETLXA)                     * *E34903*/
             CLRPFM     FILE(ASTACD) MBR(ASTACD)
             CLRPFM     FILE(ASTACA) MBR(ASTACA)
             CLRPFM     FILE(UDPMVD) MBR(UDPMVD)
             CLRPFM     FILE(UDPMVA) MBR(UDPMVA)
             CLRPFM     FILE(CDPMVD) MBR(CDPMVD)
             CLRPFM     FILE(CDPMVA) MBR(CDPMVA)
/************CLRPFM     FILE(OTHSTD) MBR(OTHSTD)              *S01176* *E34903*/
/************CLRPFM     FILE(OTHSTA) MBR(OTHSTA)              *S01176* *E34903*/
             ADDPFM     FILE(HSTTRD) MBR(NEW)
                MONMSG     MSGID(CPF0000)
             ADDPFM     FILE(CNCTRD) MBR(NEW)
                MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,SEC0602C01                                          */
 
/* CHECK FOR COMPONENT RESTART                                   */
 
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF RESTART, DISABLE ACCESS PATHS                              */
 
 
/********    IF         COND(&BUSY = 'NEW') THEN(DO)                  /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
                RMVM       FILE(TRDIP)    MBR(TRDIP)
                MONMSG     MSGID(CPF0000)
/***************RMVM       FILE(TRADS) MBR(TRADS)                       E29028*/
/***************MONMSG     MSGID(CPF0000)                               E29028*/
                RMVM       FILE(TRADSE)    MBR(TRADSE)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(TRADSR)    MBR(TRADSR)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(TRADBLCD)    MBR(TRADBLCD)
                MONMSG     MSGID(CPF0000)
 
/* IF RESTART, OVERRIDE TO SEQONLY(*YES 100)                     */
 
 
                OVRDBF     FILE(XTRADSD) SEQONLY(*YES 100)
                OVRDBF     FILE(XTRADSA) SEQONLY(*YES 100)
                OVRDBF     FILE(XHSTTRA) SEQONLY(*YES 100)
                OVRDBF     FILE(XCNCTRA) SEQONLY(*YES 100)
                OVRDBF     FILE(XCLIABD)  SEQONLY(*YES 100)
                OVRDBF     FILE(XCLIABA)  SEQONLY(*YES 100)
                OVRDBF     FILE(XSETLED)  SEQONLY(*YES 100)           /*S01176*/
                OVRDBF     FILE(XSETLEA)  SEQONLY(*YES 100)           /*S01176*/
                OVRDBF     FILE(TRADSD)  SEQONLY(*YES 100)
                OVRDBF     FILE(TRADSA)  SEQONLY(*YES 100)
                OVRDBF     FILE(HSTTRA)  SEQONLY(*YES 100)
                OVRDBF     FILE(CNCTRA)  SEQONLY(*YES 100)
                OVRDBF     FILE(CLIABD)  SEQONLY(*YES 100)
                OVRDBF     FILE(CLIABA)  SEQONLY(*YES 100)
                OVRDBF     FILE(SETLED)  SEQONLY(*YES 100)            /*S01176*/
                OVRDBF     FILE(SETLEA)  SEQONLY(*YES 100)            /*S01176*/
 
/* AND COPY FILES                                                */
 
 
                CPYF       FROMFILE(XTRADSD) TOFILE(TRADSD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM TRADSD)
                CPYF       FROMFILE(XTRADSA) TOFILE(TRADSA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM TRADSA)
                CPYF       FROMFILE(XHSTTRA) TOFILE(HSTTRA) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM HSTTRA)
                CPYF       FROMFILE(XCNCTRA) TOFILE(CNCTRA) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CNCTRA)
                CPYF       FROMFILE(XCLIABD) TOFILE(CLIABD) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CLIABD)
                CPYF       FROMFILE(XCLIABA) TOFILE(CLIABA) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CLIABA)
                CPYF       FROMFILE(XSETLED) TOFILE(SETLED) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01176*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM SETLED)                        /*S01176*/
                CPYF       FROMFILE(XSETLEA) TOFILE(SETLEA) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01176*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM SETLEA)                        /*S01176*/
/*/COPY WNCPYSRC,SEC0602C06                                          */
 
/* CHANGE DATA AREA TO 'OLD'                                    */
 
 
/********       CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
 
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XTRADSD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XTRADSA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XHSTTRA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCNCTRA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCLIABD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCLIABA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSETLED)                              /*S01176*/
                   MONMSG MSGID(CPF0000)                              /*S01176*/
                DLTF       FILE(XSETLEA)                              /*S01176*/
                   MONMSG MSGID(CPF0000)                              /*S01176*/
/*/COPY WNCPYSRC,SEC0602C07                                          */
/* COPY FILES                                                    */
 
 
/*              CPYF       FROMFILE(TRADSD) TOFILE(XTRADSD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XTRADSD)                     *  *S01129*/
/*              CPYF       FROMFILE(TRADSA) TOFILE(XTRADSA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XTRADSA)                     *  *S01129*/
/*           CPYF       FROMFILE(HSTTRA) TOFILE(XHSTTRA) +          *  *S01129*/
/*                        MBROPT(*REPLACE) FMTOPT(*NONE)            *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XHSTTRA)                     *  *S01129*/
/*           CPYF       FROMFILE(CNCTRA) TOFILE(XCNCTRA) +          *  *S01129*/
/*                        MBROPT(*REPLACE) FMTOPT(*NONE)            *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XCNCTRA)                     *  *S01129*/
/*              CPYF       FROMFILE(CLIABD) TOFILE(XCLIABD) +       *  *S01129*/
/*                         MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XCLIABD)                     *  *S01129*/
/*              CPYF       FROMFILE(CLIABA) TOFILE(XCLIABA) +       *  *S01129*/
/*                         MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XCLIABA)                     *  *S01129*/
             CPYF       FROMFILE(TRADSD) TOFILE(&TOLIB/XTRADSD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XTRADSD)                       /*S01129*/
             CPYF       FROMFILE(TRADSA) TOFILE(&TOLIB/XTRADSA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XTRADSA)                       /*S01129*/
             CPYF       FROMFILE(HSTTRA) TOFILE(&TOLIB/XHSTTRA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XHSTTRA)                       /*S01129*/
             CPYF       FROMFILE(CNCTRA) TOFILE(&TOLIB/XCNCTRA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCNCTRA)                       /*S01129*/
             CPYF       FROMFILE(CLIABD) TOFILE(&TOLIB/XCLIABD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCLIABD)                       /*S01129*/
             CPYF       FROMFILE(CLIABA) TOFILE(&TOLIB/XCLIABA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCLIABA)                       /*S01129*/
             CPYF       FROMFILE(SETLED) TOFILE(&TOLIB/XSETLED) +
MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /* S01176*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSETLED)                       /*S01176*/
             CPYF       FROMFILE(SETLEA) TOFILE(&TOLIB/XSETLEA) +
MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01176*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSETLEA)                       /*S01176*/
/*/COPY WNCPYSRC,SEC0602C08                                          */
 
/* CHANGE DATA AREA TO 'NEW'                                    */
 
 
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  DISABLE ACCESS PATHS FOR LFs NOT REQUIRED                   */
 
 
             RMVM       FILE(TRDIP) MBR(TRDIP)
             MONMSG     MSGID(CPF0000)
/************RMVM       FILE(TRADS)    MBR(TRADS)                       E29028*/
/************MONMSG     MSGID(CPF0000)                                  E29028*/
             RMVM       FILE(TRADSE)   MBR(TRADSE)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(TRADSR)  MBR(TRADSR)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(TRADBLCD) MBR(TRADBLCD)
             MONMSG     MSGID(CPF0000)
 
/* OVERRIDE FILES                                                */
 
 
             OVRDBF     FILE(SEKEYD) MBR(TRADE)
             OVRDBF     FILE(SEKEYA) MBR(TRADE)
/*           OVRDBF     FILE(SETLXD) MBR(TRADE)                  */
/*           OVRDBF     FILE(SETLXA) MBR(TRADE)                  */
             OVRDBF     FILE(HSTTRD) MBR(NEW)
             OVRDBF     FILE(CNCTRD) MBR(NEW)
/*/COPY WNCPYSRC,SEC0602C02                                          */
 
/* CALL THE PROGRAM                                              */
 
 
             CALL       PGM(SE2290)
/*/COPY WNCPYSRC,SEC0602C09                                          */
 
/* DELETE OVERRIDES                                              */
 
 
             DLTOVR     FILE(*ALL)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/*              CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 44))* *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50)) /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0602C - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE IMBALANCE ERROR                                     */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
            CHGVAR     VAR(&MEM) VALUE('SEC0602C - FILE CONTROLS OUT +
                          OF BALANCE')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/*  IF U7 & U8 OFF                                               */
 
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/*  CHANGE DATA AREA                                            */
 
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* COPY FILES  WITH MEMBER OPTION(*ADD)                          */
 
 
             CPYF       FROMFILE(HSTTRD) TOFILE(HSTTRD) FROMMBR(NEW) +
                          TOMBR(HSTTRD) MBROPT(*ADD) FMTOPT(*NONE)
             CPYF       FROMFILE(CNCTRD) TOFILE(CNCTRD) FROMMBR(NEW) +
                          TOMBR(CNCTRD) MBROPT(*ADD) FMTOPT(*NONE)
 
/*/COPY WNCPYSRC,SEC0602C03                                          */
/******** CLEAR FILES                                             */  /*S01129*/
/*                                                                  *  *S01129*/
/*                                                                  *  *S01129*/
/*           CLRPFM     FILE(XTRADSD)                               *  *S01129*/
/*           CLRPFM     FILE(XTRADSA)                               *  *S01129*/
/*           CLRPFM     FILE(XHSTTRA)                               *  *S01129*/
/*           CLRPFM     FILE(XCNCTRA)                               *  *S01129*/
/*           CLRPFM     FILE(XCLIABD)                               *  *S01129*/
/*           CLRPFM     FILE(XCLIABA)                               *  *S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XTRADSD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XTRADSA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XHSTTRA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCNCTRA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCLIABD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCLIABA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSETLED)                              /*S01176*/
                   MONMSG MSGID(CPF0000)                              /*S01176*/
                DLTF       FILE(XSETLEA)                              /*S01176*/
                   MONMSG MSGID(CPF0000)                              /*S01176*/
/*/COPY WNCPYSRC,SEC0602C10                                          */
             ENDDO
 
/*  ENABLE FILE ACCESS PATHS                                     */
 
 
ENDPGM:      ADDLFM     FILE(TRDIP)    MBR(TRDIP)
             MONMSG     MSGID(CPF0000)
/************ADDLFM     FILE(TRADS)    MBR(TRADS)                       E29028*/
/************MONMSG     MSGID(CPF0000)                                  E29028*/
             ADDLFM     FILE(TRADSE)   MBR(TRADSE)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(TRADSR)   MBR(TRADSR)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(TRADBLCD) MBR(TRADBLCD)
             MONMSG     MSGID(CPF0000)
 
/*  REMOVE PHYSICAL MEMBERS                                      */
 
             RMVM       FILE(HSTTRD) MBR(NEW)
             RMVM       FILE(CNCTRD) MBR(NEW)
/*/COPY WNCPYSRC,SEC0602C04                                          */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
