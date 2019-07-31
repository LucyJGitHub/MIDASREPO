/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Generate A/c Keys-Bk Posn Maturts')          */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0607A - GENERATE A/C KEYS - BOOK POSITION MATURITIES    */
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
/*                      E23322                  DATE  15AUG90       */
/*                      E16870                  DATE  08/03/89      */
/*                      E15686                  DATE  11/10/88      */
/*                      S01179                  DATE  16/09/88      */
/*                      E14236                  DATE  10/09/88      */
/*                      S01129                  DATE  31/03/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hook SEC0607AM1                  *  *E15549*/
/*       S01117 - MULTIBRANCHING                                    */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            */
/*       E23322 - CODE RELATING TO LF/BKPOSJF REMOVED AND           */
/*                REDUNDANT CODE DECLARING &SESDS AND &LDA REMOVED  */
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                    *  *E16870*/
/*       E15686 - CHANGE XBKPOSD TO CRTFILE(*YES) AND DELETE AT END *  *E15686*/
/*       S01179 - ABS INCORPORATION                                 *  *S01179*/
/*       E14236 - MATURE POSITIONS AND HOLDINGS.                    *  *E14236*/
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
 
/*           DCLDTAARA  DTAARA(SESTAT)                              *  *S01179*/
/*           DCLDTAARA  DTAARA(SDSTAT)                    *  *S01129*  *S01179*/
/************DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)       S01179E23322*/
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)      *S01179E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)       E16870E23322*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(79)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                * *S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
                                                                      /*S01129*/
/*           RCVDTAARA DTAARA(SDSTAT)                     *  *S01129*  *S01179*/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)                 /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0607AM1                                          */
                                                                      /*S01408*/
 
/*  SETUP AND SEND PGM MESSAGE                                      */
 
             CHGVAR     VAR(&MSG) VALUE('SEC0607A - Generate A/C Keys +
                          - Book Position Maturities')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/*  SET OFF ALL SWITCHES                                            */
 
             CHGJOB SWS(00000000)
 
/*  CLEAR OUTPUT FILES                                              */
 
/* ******    CLRPFM     FILE(SEKEYD) MBR(TRADE)      */
             CLRPFM     FILE(SEKEYD) MBR(BKMATUR)
/* ******    CLRPFM     FILE(SEKEYA) MBR(TRADE)      */
             CLRPFM     FILE(SEKEYA) MBR(BKMATUR)
             CLRPFM     FILE(MATEXD) MBR(BOOK)
             CLRPFM     FILE(MATEXA) MBR(BOOK)
 
/*  CHECK FOR COMPONENT RESTART                                     */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)           * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  IF RESTART, DISABLE ACCESS PATHS                                */
 
/************IF         COND(&BUSY = 'NEW') THEN(DO)                 * *S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
                RMVM       FILE(BKPHJ3V)    MBR(BKPHJ3V)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ3T)    MBR(BKPHJ3T)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ1)     MBR(BKPHJ1)
                MONMSG     MSGID(CPF0000)
/***************RMVM       FILE(BKPOSJF)     MBR(BKPOSJF)               E23322*/
/***************MONMSG     MSGID(CPF0000)                               E23322*/
                RMVM       FILE(BKPBK)      MBR(BKPBK)
                MONMSG     MSGID(CPF0000)
/*              RMVM       FILE(BKPHD)      MBR(BKPHD)              */
/*              MONMSG     MSGID(CPF0000)                           */
/*              RMVM       FILE(BKPOS)      MBR(BKPOS)              */
/*              MONMSG     MSGID(CPF0000)                           */
   /* ******    RMVM       FILE(BKPHV)      MBR(BKPHV)       */
   /*           MONMSG     MSGID(CPF0000)                    */
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
 
                OVRDBF     FILE(XBKPHDD) SEQONLY(*YES 100)
        /* ***  OVRDBF     FILE(XBKPOSD) SEQONLY(*YES 100) */
                OVRDBF     FILE(XBKPOSD) SEQONLY(*YES 100)            /*E14236*/
                OVRDBF     FILE(XBKPHDA) SEQONLY(*YES 100)
                OVRDBF     FILE(BKPHDD)  SEQONLY(*YES 100)
        /* ***  OVRDBF     FILE(BKPOSD)  SEQONLY(*YES 100) */
                OVRDBF     FILE(BKPOSD)  SEQONLY(*YES 100)            /*E14236*/
                OVRDBF     FILE(BKPHDA)  SEQONLY(*YES 100)
 
/*  AND COPY FILES                                                  */
 
                CPYF       FROMFILE(XBKPHDD) TOFILE(BKPHDD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHDD)
                CPYF       FROMFILE(XBKPHDA) TOFILE(BKPHDA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHDA)
                CPYF       FROMFILE(XBKPOSD) TOFILE(BKPOSD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*E14236*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPOSD)                       /*E14236*/
 
/*  CHANGE DATA AREA TO 'OLD'                                      */
 
/***************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')         * *S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
 
/*  ELSE BACKUP FILES                                               */
 
             ELSE       CMD(DO)
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
 
                OVRDBF     FILE(BKPHDD)  SEQONLY(*YES 100)
                OVRDBF     FILE(BKPHDA)  SEQONLY(*YES 100)
                OVRDBF     FILE(BKPOSD)  SEQONLY(*YES 100)            /*E14236*/
                OVRDBF     FILE(XBKPHDD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPHDA) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKODSD) SEQONLY(*YES 100)            /*E14236*/
/*                                                                  *  *S01129*/
 
/*  AND COPY FILES                                                 */
 
/*              CPYF       FROMFILE(BKPHDD) TOFILE(XBKPHDD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XBKPHDD)                    *  *S01129*/
/*              CPYF       FROMFILE(BKPHDA) TOFILE(XBKPHDA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XBKPHDA)                    *  *S01129*/
             CPYF       FROMFILE(BKPHDD) TOFILE(&TOLIB/XBKPHDD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPHDD)                      /*S01129*/
             CPYF       FROMFILE(BKPHDA) TOFILE(&TOLIB/XBKPHDA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPHDA)                      /*S01129*/
/*              CPYF       FROMFILE(BKPOSD) TOFILE(XBKPOSD) +      */ /*E15686*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)   E14236*/ /*E15686*/
                CPYF       FROMFILE(BKPOSD) TOFILE(&TOLIB/XBKPOSD) +
MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)                          /*E15686*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPOSD)                      /*E14236*/
 
/*  DISABLE ALL ACCESS PATHS NOT USED BY RPG                        */
 
                RMVM       FILE(BKPHJ3V)    MBR(BKPHJ3V)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ3T)    MBR(BKPHJ3T)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ1)     MBR(BKPHJ1)
                MONMSG     MSGID(CPF0000)
/***************RMVM       FILE(BKPOSJF)     MBR(BKPOSJF)               E23322*/
/***************MONMSG     MSGID(CPF0000)                               E23322*/
                RMVM       FILE(BKPBK)      MBR(BKPBK)
                MONMSG     MSGID(CPF0000)
       /*       RMVM       FILE(BKPHV)      MBR(BKPHV)     */
       /*       MONMSG     MSGID(CPF0000)                  */
 
             ENDDO
 
/*  CHANGE DATA AREA TO 'NEW'                                       */
 
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')            * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  OVERRIDE FILES                                                  */
 
                OVRDBF     FILE(SEKEYD) TOFILE(SEKEYD) MBR(BKMATUR)
                OVRDBF     FILE(SEKEYA) TOFILE(SEKEYA) MBR(BKMATUR)
                OVRDBF     FILE(MATEXD) TOFILE(MATEXD) MBR(BOOK)
                OVRDBF     FILE(MATEXA) TOFILE(MATEXA) MBR(BOOK)
 
/*  CALL PROGRAM                                                    */
 
             CALL       PGM(SE2270)
 
             DLTOVR     FILE(*ALL)
 
/*  FOR DATABASE ERRORS RECOVER DATA FROM LDA                       */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0607A - Job Terminated, +
                                         Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/*  FOR FILE CONTROLS OUT OF BALANCE ERROR                          */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC0607A - File Controls Out +
                                         Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/*  IF U7 AND U8 OFF, CHANGE SESTAT TO "OLD"                       */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/**************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
               CHGVAR     VAR(&BUSY) VALUE('N')                       /*S01189*/
               CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
 
/*  CLEAR FILES                                                    */
 
/*             CLRPFM     FILE(XBKPOSD)                             *  *S01129*/
/*             CLRPFM     FILE(XBKPHDD)                             *  *S01129*/
/*  DELETE COPY FILES                                               *  *S01129*/
/*                                                                  *  *S01129*/
                DLTF       FILE(XBKPHDD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XBKPHDA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XBKPOSD)                              /*E15686*/
                   MONMSG MSGID(CPF0000)                              /*E15686*/
 
             ENDDO
 
ENDPGM:      ADDLFM     FILE(BKPHJ3V)    MBR(BKPHJ3V)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(BKPHJ3T)    MBR(BKPHJ3T)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(BKPHJ1)     MBR(BKPHJ1)
             MONMSG     MSGID(CPF0000)
/************ADDLFM     FILE(BKPOSJF)    MBR(BKPOSJF)                   E23322*/
/************MONMSG     MSGID(CPF0000)                                  E23322*/
             ADDLFM     FILE(BKPBK)      MBR(BKPBK)
             MONMSG     MSGID(CPF0000)
    /*       ADDLFM     FILE(BKPHV)      MBR(BKPHV)      */
    /*       MONMSG     MSGID(CPF0000)                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
