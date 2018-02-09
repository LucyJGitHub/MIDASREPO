/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Update Bk Pos with Next Day Trade')          */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0606K - UPDATE BOOK POSITION I/C FIELDS WITH DETAILS    */
/*                  OF NEXT DAY'S TRADES                            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 11May95              */
/*                      S01117             Date 08Jan91              */
/*                      S01189                  DATE  08JAN91       */
/*                      E21114                  DATE  13FEB90       */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hook SEC0606KMS                  *  *E15549*/
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01189  -  CLOSE OF BUSINESS IMPROVEMENTS PHASE 2          */
/*       E21114  -  NEW PROGRAM.                                    */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                * *S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)          * *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
 
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')             S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0606KMS                                          */
                                                                      /*S01408*/
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0606K - Update Book +
                          Positions I/C fields')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* CHECK FOR COMPONENT RESTART                                      */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)           * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF RESTART DISABLE RELATED ACCESS PATHS                          */
 
/************IF COND(&BUSY = 'NEW') THEN(DO)                         * *S01189*/
             IF COND(&BUSY = 'Y') THEN(DO)                            /*S01189*/
 
                RMVM       FILE(BKPHDJF2) MBR(BKPHDJF2)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BKPHJ1) MBR(BKPHJ1)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BKPHJ3V) MBR(BKPHJ3V)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BKPHS) MBR(BKPHS)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BPOHTR) MBR(BPOHTR)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BPOHVL) MBR(BPOHVL)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BKPOSDT) MBR(BKPOSDT)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BKPOSS) MBR(BKPOSS)
                MONMSG MSGID(CPF0000)
 
/* OVERRIDE FILES                       */
 
                OVRDBF FILE(BKPHDD)  SEQONLY(*YES 100)
                OVRDBF FILE(BKPHDA)  SEQONLY(*YES 1)
                OVRDBF FILE(XBKPHDD) SEQONLY(*YES 100)
                OVRDBF FILE(XBKPHDA) SEQONLY(*YES 1)
                OVRDBF FILE(BKPOSD)  SEQONLY(*YES 100)
                OVRDBF FILE(BKPOSA)  SEQONLY(*YES 1)
                OVRDBF FILE(XBKPOSD) SEQONLY(*YES 100)
                OVRDBF FILE(XBKPOSA) SEQONLY(*YES 1)
 
/* AND COPY FILES                       */
 
                CPYF FROMFILE(XBKPHDD) TOFILE(BKPHDD) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM BKPHDD)
 
                CPYF FROMFILE(XBKPHDA) TOFILE(BKPHDA) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM BKPHDA)
 
                CPYF FROMFILE(XBKPOSD) TOFILE(BKPOSD) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM BKPOSD)
 
                CPYF FROMFILE(XBKPOSA) TOFILE(BKPOSA) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM BKPOSA)
 
/* CHANGE DATA AREA                     */
 
/***************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
                CHGVAR    VAR(&BUSY) VALUE('N')                       /*S01189*/
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
 
             ENDDO
 
/*   OVERRIDE FILES                                                 */
 
                OVRDBF FILE(BKPHDD)  SEQONLY(*YES 100)
                OVRDBF FILE(BKPHDA)  SEQONLY(*YES 1)
                OVRDBF FILE(XBKPHDD) SEQONLY(*YES 100)
                OVRDBF FILE(XBKPHDA) SEQONLY(*YES 1)
                OVRDBF FILE(BKPOSD)  SEQONLY(*YES 100)
                OVRDBF FILE(BKPOSA)  SEQONLY(*YES 1)
                OVRDBF FILE(XBKPOSD) SEQONLY(*YES 100)
                OVRDBF FILE(XBKPOSA) SEQONLY(*YES 1)
 
/* DELETE COPY FILES                               */
 
                DLTF       FILE(XBKPHDD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XBKPHDA)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XBKPOSD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XBKPOSA)
                   MONMSG MSGID(CPF0000)
 
             CPYF FROMFILE(BKPHDD) TOFILE(&TOLIB/XBKPHDD) +
             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XBKPHDD)
 
             CPYF FROMFILE(BKPHDA) TOFILE(&TOLIB/XBKPHDA) +
             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XBKPHDA)
 
             CPYF FROMFILE(BKPOSD) TOFILE(&TOLIB/XBKPOSD) +
             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XBKPOSD)
 
             CPYF FROMFILE(BKPOSA) TOFILE(&TOLIB/XBKPOSA) +
             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XBKPOSA)
 
/* CHANGE DATA AREA   TO 'NEW'          */
 
/************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('NEW')             * *S01189*/
             CHGVAR    VAR(&BUSY) VALUE('Y')                          /*S01189*/
             CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)                 /*S01189*/
 
/*   DISABLE ACCESS PATHS FOR LOGICALS NOT REQUIRED BY THIS RPG     */
 
                RMVM       FILE(BKPHDJF2) MBR(BKPHDJF2)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BKPHJ1) MBR(BKPHJ1)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BKPHJ3V) MBR(BKPHJ3V)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BKPHS) MBR(BKPHS)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BPOHTR) MBR(BPOHTR)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BPOHVL) MBR(BPOHVL)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BKPOSDT) MBR(BKPOSDT)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(BKPOSS) MBR(BKPOSS)
                MONMSG MSGID(CPF0000)
 
/*  CALL SE2340 (UPDATE) */
 
             CALL       PGM(SE2340)
 
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0606K - Job Terminated, +
                          Database in Error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
 
/* NORMAL COMPLETION - CLEAR OUTPUT FILES */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/* CHANGE DATA AREA   TO 'NEW'          */
 
/***************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
                CHGVAR    VAR(&BUSY) VALUE('N')                       /*S01189*/
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
 
                DLTF       FILE(XBKPHDD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XBKPHDA)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XBKPOSD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XBKOSDA)
                   MONMSG MSGID(CPF0000)
 
             ENDDO
 
/*    ENABLE ACCESS PATHS  */
 
ENDPGM:         ADDLFM   FILE(BKPHDJF2) MBR(BKPHDJF2)
                MONMSG MSGID(CPF0000)
                ADDLFM     FILE(BKPHJ1) MBR(BKPHJ1)
                MONMSG MSGID(CPF0000)
                ADDLFM     FILE(BKPHJ3V) MBR(BKPHJ3V)
                MONMSG MSGID(CPF0000)
                ADDLFM     FILE(BKPHS) MBR(BKPHS)
                MONMSG MSGID(CPF0000)
                ADDLFM     FILE(BPOHTR) MBR(BPOHTR)
                MONMSG MSGID(CPF0000)
                ADDLFM     FILE(BPOHVL) MBR(BPOHVL)
                MONMSG MSGID(CPF0000)
                ADDLFM     FILE(BKPOSDT) MBR(BKPOSDT)
                MONMSG MSGID(CPF0000)
                ADDLFM     FILE(BKPOSS) MBR(BKPOSS)
                MONMSG MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                ENDPGM
