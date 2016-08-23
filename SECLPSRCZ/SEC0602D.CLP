/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Generate A/c Keys - Trade Settls.')          */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0602D  GENERATE A/C KEYS - TRADE SETTLEMENTS            */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408                  DATE 10MAY95        */
/*       PREV AMEND NO. S01189                  DATE  07JAN91       */
/*                      S01117                  DATE  10DEC90       */
/*                      E23543                  DATE  10SEP90       */
/*                      E16870                  DATE  08/03/89      */
/*                      S01129                  DATE  31/03/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*     S01408 - Addition of core hook SEC0602DMS                    */
/*     S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2              */
/*     S01117 - MULTIBRANCHING                                      */
/*     E23543 - TAKE SECURITY COPIES OF SETLED AND SETLEA IN CASE   */
/*              OF RESTART - THESE FILES ARE UPDATED IN SE2260      */
/*              ALSO, ACCESS PATH PROCESSING REMOVED SINCE IT IS    */
/*              MORE EFFICIENT JUST TO BUILD ACCESS PATH FOR EACH   */
/*              RECORD ADDED TO FILES IN SE2260.                    */
/*     E16870 - SESTAT REDEFINED AS 128 BYTES.                      */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/********    PGM                                                      /*S01189*/
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
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
                                                                      /*S01179*/
/************DCLDTAARA**DTAARA(LDA)                                    *S01179*/
/************DCLDTAARA**DTAARA(SESTAT)                                 *S01179*/
/************DCLDTAARA**DTAARA(SDSTAT)                          *S01129*S01179*/
/************DCL********VAR(&LDA)     TYPE(*CHAR)  LEN(256)     *S01179*E23543*/
/************DCL********VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)     *S01179*E16870*/
/************DCL********VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)     *E16870*E23543*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*S01179*/
                                                                      /*S01129*/
/************RCVDTAARA*DTAARA(SDSTAT)                           *S01129*S01179*/
             RTVDTAARA DTAARA(SDSTAT)  RTNVAR(&SDSTAT)                /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0602DMS                                          */
                                                                      /*S01408*/
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MSG) VALUE('SEC0602D - GENERATE A/C KEYS +
                          - TRADE SETTLEMENT')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* SET OFF SWITCHES                                              */
 
             CHGJOB     SWS(00000000)
 
/* CLEAR OUTPUT FILES                                            */
 
             CLRPFM     FILE(SEKEYD) MBR(TSETTLE)
             CLRPFM     FILE(SEKEYA) MBR(TSETTLE)
             CLRPFM     FILE(SETACD) MBR(SETACD)
             CLRPFM     FILE(SETACA) MBR(SETACA)
 
/* CHECK FOR COMPONENT RESTART                                   */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/********    IF         COND(&BUSY = 'NEW') THEN(DO)                  /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
/**IF*RESTART,*DISABLE*ACCESS*PATHS******                              *E23543*/
/***************RMVM*******FILE(TRDIP)     MBR(TRDIP)                  *E23543*/
/***************MONMSG*****MSGID(CPF0000)                              *E23543*/
/***************RMVM*******FILE(TRADSE)    MBR(TRADSE)                 *E23543*/
/***************MONMSG*****MSGID(CPF0000)                              *E23543*/
/***************RMVM*******FILE(TRADSR)    MBR(TRADSR)                 *E23543*/
/***************MONMSG*****MSGID(CPF0000)                              *E23543*/
/***************RMVM*******FILE(TRADBLCD)  MBR(TRADBLCD)               *E23543*/
/***************MONMSG*****MSGID(CPF0000)                              *E23543*/
/***************RMVM*******FILE(TRDBR)     MBR(TRDBR)                  *E23543*/
/***************MONMSG*****MSGID(CPF0000)                              *E23543*/
 
/* OVERRIDE TO SEQONLY(*YES 100)                                 */
 
                OVRDBF     FILE(XTRADSD) SEQONLY(*YES 100)
                OVRDBF     FILE(TRADSD)  SEQONLY(*YES 100)
                OVRDBF     FILE(XSETLEA) SEQONLY(*YES 100)            /*E23543*/
                OVRDBF     FILE(SETLEA)  SEQONLY(*YES 100)            /*E23453*/
                OVRDBF     FILE(XSETLED) SEQONLY(*YES 100)            /*E23543*/
                OVRDBF     FILE(SETLED)  SEQONLY(*YES 100)            /*E23543*/
 
/* AND COPY FILES                                                */
 
                CPYF       FROMFILE(XTRADSD) TOFILE(TRADSD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM TRADSD)
                CPYF       FROMFILE(XSETLED) TOFILE(SETLED) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*E23543*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM SETLED)                        /*E23543*/
                CPYF       FROMFILE(XSETLEA) TOFILE(SETLEA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*E23543*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM SETLEA)                        /*E23543*/
 
/**CHANGE*DATA*AREA*TO*'OLD'********************************           *E23543*/
/***************CHGDTAARA**DTAARA(SESTAT*(1 3))*VALUE('OLD')           *E23543*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
 
             ELSE       CMD(DO)                                       /*E23543*/
 
/* IF NOT RESTART, TAKE SECURITY COPIES OF MASTER FILES                *E23543*/
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                DLTF       FILE(XTRADSD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSETLED)                              /*E23543*/
                   MONMSG MSGID(CPF0000)                              /*E23543*/
                DLTF       FILE(XSETLEA)                              /*E23543*/
                   MONMSG MSGID(CPF0000)                              /*E23543*/
 
/* COPY FILES                                                    */
 
/***************CPYF*******FROMFILE(TRADSD) TOFILE(XTRADSD) +      */ /*S01129*/
/***************************MBROPT(*REPLACE) FMTOPT(*NONE)         */ /*S01129*/
/***************MONMSG*****(CPF2817) CMPDTA(CPF2869) +             */ /*S01129*/
/**************************EXEC(CLRPFM XTRADSD)                    */ /*S01129*/
             CPYF       FROMFILE(TRADSD) TOFILE(&TOLIB/XTRADSD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XTRADSD)                       /*S01129*/
             CPYF       FROMFILE(SETLED) TOFILE(&TOLIB/XSETLED) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*E23543*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSETLED)                       /*E23543*/
             CPYF       FROMFILE(SETLEA) TOFILE(&TOLIB/XSETLEA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*E23543*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSETLEA)                       /*E23543*/
 
             ENDDO                                                    /*E23543*/
 
/* CHANGE DATA AREA TO 'NEW'                                    */
 
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')             /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('Y')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
/***DISABLE*ACCESS*PATHS*FOR*LFs*NOT*REQUIRED****                      *E23543*/
/************RMVM*******FILE(TRDBR)     MBR(TRDBR)                     *E23543*/
/************MONMSG*****MSGID(CPF0000)                                 *E23543*/
/************RMVM*******FILE(TRDIP)     MBR(TRDIP)                     *E23543*/
/************MONMSG*****MSGID(CPF0000)                                 *E23543*/
/************RMVM*******FILE(TRADSE)    MBR(TRADSE)                    *E23543*/
/************MONMSG*****MSGID(CPF0000)                                 *E23543*/
/************RMVM*******FILE(TRADSR)    MBR(TRADSR)                    *E23543*/
/************MONMSG*****MSGID(CPF0000)                                 *E23543*/
/************RMVM*******FILE(TRADBLCD)  MBR(TRADBLCD)                  *E23543*/
/************MONMSG*****MSGID(CPF0000)                                 *E23543*/
 
/* OVERRIDE FILES                                                */
 
             OVRDBF     FILE(SEKEYD) MBR(TSETTLE)
             OVRDBF     FILE(SEKEYA) MBR(TSETTLE)
 
/* CALL THE PROGRAM                                              */
 
             CALL       PGM(SE2260)
 
/* DELETE OVERRIDE                                               */
 
             DLTOVR     FILE(*ALL)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/*              CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 44))  *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50)) /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0602D - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE IMBALANCE ERROR */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
            CHGVAR     VAR(&MEM) VALUE('SEC0602D - FILE CONTROLS OUT +
                          OF BALANCE')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/*  IF NO ERRORS CLEAR FILES                                     */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*           CLRPFM     FILE(XSECTYD)                               *  *S01129*/
                DLTF       FILE(XTRADSD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSETLED)                              /*E23543*/
                   MONMSG MSGID(CPF0000)                              /*E23543*/
                DLTF       FILE(XSETLEA)                              /*E23543*/
                   MONMSG MSGID(CPF0000)                              /*E23543*/
 
             ENDDO
 
/***ENABLE*FILE*ACCESS*PATHS*********                                **E23543*/
/*ENDPGM:****ADDLFM*****FILE(TRDIP)    MBR(TRDIP)                     *E23543*/
/************MONMSG*****MSGID(CPF0000)                                *E23543*/
/************ADDLFM*****FILE(TRDBR)    MBR(TRDBR)                     *E23543*/
/************MONMSG*****MSGID(CPF0000)                                *E23543*/
/************ADDLFM*****FILE(TRADSE)   MBR(TRADSE)                    *E23543*/
/************MONMSG*****MSGID(CPF0000)                                *E23543*/
/************ADDLFM*****FILE(TRADSR)   MBR(TRADSR)                    *E23543*/
/************MONMSG*****MSGID(CPF0000)                                *E23543*/
/************ADDLFM*****FILE(TRADBLCD) MBR(TRADBLCD)                  *E23543*/
/************MONMSG*****MSGID(CPF0000)                                *E23543*/
/************ENDPGM*******************                                *E23543*/
/*ENDPGM:*****ENDPGM                                          *S01117* *E23543*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
