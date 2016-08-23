/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Ext Commercial Paper Price Chnges')          */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0602H  EXTRACT COMMERCIAL PAPER PRICE CHANGES           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408              DATE 10MAY95            */
/*       PREV AMEND NO. S01189              DATE  07JAN91           */
/*                      S01117              DATE  10DEC90           */
/*                      E16870              DATE  08/03/89          */
/*                      S01179              DATE  16/12/88          */
/*                      S01176              DATE  30/11/88          */
/*                                                                  */
/********************************************************************/
/*       S01408 - Addition of core hook SEC0602HMS                  */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            */
/*       S01117 - MULTBRANCHING                                      */
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                    *   E16870*/
/*       S01179 - AS400 CHANGES                                     */
/*       S01176 - SECURITIES TRADING 3.1 (NEW PROGRAM)              */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/********    DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
/*           DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)                 *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)            *E16870*/
/********    DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
                MONMSG MSGID(CPF2817)
 
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0602HMS                                          */
                                                                      /*S01408*/
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MSG) VALUE('SEC0602H - EXTRACT COMM. +
                          PAPER PRICES CHANGES')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* SET OFF SWITCHES                                              */
 
             CHGJOB     SWS(00000000)
 
/* CHECK FOR COMPONENT RESTART                                   */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF RESTART, DISABLE ACCESS PATHS                              */
 
/********    IF         COND(&BUSY = 'NEW') THEN(DO)                  /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
/* IF RESTART, OVERRIDE TO SEQONLY(*YES 100)                     */
 
                OVRDBF     FILE(XSECTYD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(XCPPRIA) SEQONLY(*YES 100)
                OVRDBF     FILE(SECTYD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVA)  SEQONLY(*YES 100)
                OVRDBF     FILE(CPPRIA)  SEQONLY(*YES 100)
 
/* AND COPY FILES                                                */
 
                CPYF       FROMFILE(XSECTYD) TOFILE(SECTYD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM SECTYD)
                CPYF       FROMFILE(XSNDEVD) TOFILE(SNDEVD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM SNDEVD)
                CPYF       FROMFILE(XSNDEVA) TOFILE(SNDEVA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSNDEVA)
                CPYF       FROMFILE(XCPPRIA) TOFILE(CPPRIA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CPPRIA)
 
/* CHANGE DATA AREA TO 'OLD'                                    */
 
/********       CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
/**/
 
             ENDDO
 
/**/
 
/* DELETE COPY FILES                               */
 
                DLTF       FILE(XSECTYD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XSNDEVD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XSNDEVA)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XCPPRIA)
                   MONMSG MSGID(CPF0000)
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                */
 
                OVRDBF     FILE(XSECTYD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(XCPPRIA) SEQONLY(*YES 100)
                OVRDBF     FILE(SECTYD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVA)  SEQONLY(*YES 100)
                OVRDBF     FILE(CPPRIA)  SEQONLY(*YES 100)
 
/* AND COPY FILES                                                */
 
                CPYF       FROMFILE(SECTYD) TOFILE(&TOLIB/XSECTYD) +
MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSECTYD)
                CPYF       FROMFILE(SNDEVD) TOFILE(&TOLIB/XSNDEVD) +
MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSNDEVD)
                CPYF       FROMFILE(SNDEVA) TOFILE(&TOLIB/XSNDEVA) +
MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSNDEVA)
                CPYF       FROMFILE(CPPRIA) TOFILE(&TOLIB/XCPPRIA) +
MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCPPRIA)
 
/* CHANGE DATA AREA TO 'NEW'                                    */
 
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/**/
 
 
 
/* CALL THE PROGRAM                                              */
 
             CALL       PGM(SE5120)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/*              CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 44))  *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50)) /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0602H - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE IMBALANCE ERROR */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
            CHGVAR     VAR(&MEM) VALUE('SEC0602B - FILE CONTROLS OUT +
                          OF BALANCE')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/*  IF NO ERRORS CLEAR FILES                                     */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
                DLTF       FILE(XSECTYD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XSNDEVD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XSNDEVA)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XCPPRIA)
                   MONMSG MSGID(CPF0000)
 
             ENDDO
 
/*  ENABLE FILE ACCESS PATHS                                     */
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
