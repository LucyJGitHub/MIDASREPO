/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Update Depot Positions')                     */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0606C - UPDATE PAST AND CURRENT  DEPOT POSITIONS        */
/*                  WITH THE EFFECT OF TRADES,DEPOT MOVEMENTS       */
/*                  AND TRADE SETTLEMENTS                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG11615           Date 26Jun06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 11May95              */
/*                      S01117             Date 08Jan91              */
/*                      S01189             DATE 08JAN91             */
/*                      E19833             DATE 16OCT89             */
/*                      E16870             DATE 08/03/89            */
/*                      S01179             DATE 16/12/88            */
/*                      E15777             DATE 15/10/88            */
/*                      E15616             DATE 11/10/88            */
/*                      E15549             DATE 06/10/88            */
/*                      E14753             DATE 05/09/88            */
/*                      S01158             DATE 26/05/88            */
/*                      S01129             DATE 31/03/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       BUG11615 - SEC0606C 00001 failed ; field DDPT won't map    */
/*                  from file DPOSND                                */
/*       S01408 - Addition of core hook SEC0606CMS                  */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            *   S01189*/
/*       E19833 - PARAMETER '&ACCRX' BECAME 'ACCRX'                 *  *E19833*/
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                    *  *E16870*/
/*       S01179 - AS400 CHANGES TO COMMANDS                         */
/*       E15777 - RECLAIM RESOURCES BEFORE CLEAR OF FILE XDPOSND    */
/*       E15616 - XDPOSND & XCPOSND MUST ALWAYS BE IN EXISTENCE     */
/*       E15549 - SECURITIES TRADING  FIXES INVOLVING POSITION      */
/*                SETTLEMENTS                                       */
/*       E14753 - DEPOT POSITIONS UPDATE DOES NOT INCLUDE PORTFOLIO */
/*       S01158 - POST SE INCORPORATION ERROR FIX.                  */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM */                                                   /*E15549*/
/************PGM        PARM(&ACCRX)                          *E15549* *S01189*/
             PGM        PARM(&ACCRX &CNAM &CSEQ)                      /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
             DCL        VAR(&ACCRX) TYPE(*CHAR) LEN(1)                /*E15549*/
 
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)            *E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*S01129*/
/*/COPY WNCPYSRC,SEC0606C01                                          */
                                                                      /*S01129*/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)                 /*S01129*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0606CMS                                          */
                                                                      /*S01408*/
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0606C - Update Depot +
                          Positions')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)
 
/*/COPY WNCPYSRC,SEC0606C02                                          */
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* CLEAR OUTPUT FILES  */
 
             CLRPFM     FILE(SEKEYD) MBR(DPOSN1)
             CLRPFM     FILE(SEKEYA) MBR(DPOSN1)
             CLRPFM     FILE(POSETD) MBR(DPOSN1)
             CLRPFM     FILE(POSETA) MBR(DPOSN1)
/*/COPY WNCPYSRC,SEC0606C03                                          */
 
/* CHECK FOR COMPONENT RESTART                                      */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF RESTART DISABLE RELATED ACCESS PATHS                          */
 
/********    IF COND(&BUSY = 'NEW') THEN(DO)                          /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
                RMVM       FILE(DPOSS) MBR(DPOSS)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(DPOSO) MBR(DPOSO)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(DPOSN) MBR(DPOSN)
                MONMSG MSGID(CPF0000)
 
/* OVERRIDE FILES                       */
 
                OVRDBF FILE(DPOSND)  SEQONLY(*YES 100)
                OVRDBF FILE(DPOSNA)  SEQONLY(*YES 1)
/*              OVRDBF FILE(XDPOSND) SEQONLY(*YES 100)           */
/*              OVRDBF FILE(XDPOSNA) SEQONLY(*YES 1)             */
 
/* AND COPY FILES                       */
 
/**********     CPYF FROMFILE(XDPOSND) TOFILE(DPOSND) + */                              /*BUG11615*/
/**********     MBROPT(*REPLACE) FMTOPT(*NONE) */                                       /*BUG11615*/
                CPYF FROMFILE(XDPOSND) TOFILE(DPOSND) +
                MBROPT(*REPLACE) FMTOPT(*NOCHK)                                         /*BUG11615*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM DPOSND)
 
                CPYF FROMFILE(XDPOSNA) TOFILE(DPOSNA) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM DPOSNA)
/*/COPY WNCPYSRC,SEC0606C05                                          */
 
/* CHANGE DATA AREA                     */
 
/********       CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')           /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
 
/*   SAVE TO BE UPDATED FILES TO X(filename)                        */
 
             OVRDBF FILE(DPOSND) SEQONLY(*YES 100)
             OVRDBF FILE(DPOSNA) SEQONLY(*YES 1)
/*           OVRDBF FILE(XDPOSND) SEQONLY(*YES 100)                 */
/*           OVRDBF FILE(XDPOSNA) SEQONLY(*YES 1)                   */
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
/*              DLTF       FILE(XDPOSND)           */       /*S01129*  *S01158*/
/*                 MONMSG MSGID(CPF0000)           */       /*S01129*  *S01158*/
                DLTF       FILE(XDPOSNA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
/*/COPY WNCPYSRC,SEC0606C06                                          */
 
/*           CPYF FROMFILE(DPOSND) TOFILE(XDPOSND) +                *  *S01129*/
/*           MBROPT(*REPLACE) FMTOPT(*NONE)                         *  *S01129*/
/*           MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +                *  *S01129*/
/*           EXEC(CLRPFM XDPOSND)                                   *  *S01129*/
/*                                                                  *  *S01129*/
/*           CPYF FROMFILE(DPOSNA) TOFILE(XDPOSNA) +                *  *S01129*/
/*           MBROPT(*REPLACE) FMTOPT(*NONE)                         *  *S01129*/
/*           MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +                *  *S01129*/
/*           EXEC(CLRPFM XDPOSNA)                                   *  *S01129*/
/************CPYF FROMFILE(DPOSND) TOFILE(XDPOSND.&TOLIB) + */        /*E15616*/
/************MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) *  *S01129*  * +
E15616*/
/**********  CPYF FROMFILE(DPOSND) TOFILE(XDPOSND) + */                                 /*BUG11615*/
/**********  MBROPT(*REPLACE) FMTOPT(*NONE) */                               /*E15616*/ /*BUG11615*/
             CPYF FROMFILE(DPOSND) TOFILE(XDPOSND) +
             MBROPT(*REPLACE) FMTOPT(*NOCHK)                                            /*BUG11615*/
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XDPOSND)                                     /*S01129*/
                                                                      /*S01129*/
             CPYF FROMFILE(DPOSNA) TOFILE(&TOLIB/XDPOSNA) +
             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)             /*S01129*/
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XDPOSNA)                                     /*S01129*/
/*/COPY WNCPYSRC,SEC0606C07                                          */
 
/* CHANGE DATA AREA   TO 'NEW'          */
 
/********    CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('NEW')              /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*   DISABLE ACCESS PATHS FOR LOGICALS NOT REQUIRED BY THIS RPG     */
 
                RMVM       FILE(DPOSN) MBR(DPOSN)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(DPOSO) MBR(DPOSO)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(DPOSS) MBR(DPOSS)
                MONMSG MSGID(CPF0000)
 
/* SETUP PORTFOLIO TRADE ACTIONS        */                            /*E14753*/
                                                                      /*E14753*/
             CPYF       FROMFILE(TRDACD) TOFILE(PTRDAD) +
                          MBROPT(*REPLACE) INCREL((*IF PTFI *EQ 'Y')) /*E14753*/
             MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PTRDAD))      /*E14753*/
                                                                      /*E14753*/
             CPYF       FROMFILE(SETACD) TOFILE(PSETAD) +
                          MBROPT(*REPLACE) INCREL((*IF SPFI *EQ 'Y')) /*E14753*/
             MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PSETAD))      /*E14753*/
                                                                      /*E14753*/
/* OVERRIDE FILES                       */
 
             OVRDBF     FILE(SEKEYD) MBR(DPOSN1)
             OVRDBF     FILE(SEKEYA) MBR(DPOSN1)
             OVRDBF     FILE(POSETD) MBR(DPOSN1)
             OVRDBF     FILE(POSETA) MBR(DPOSN1)
             OVRDBF     FILE(DPOSHI) TOFILE(DPOSH) SHARE(*NO)
/*/COPY WNCPYSRC,SEC0606C04                                          */
 
/* SET UP VALUE OF &ACCRX FOR ORDINARY DAY RUN */                     /*S01189*/
 
             IF         COND(&ACCRX *EQ ' ') THEN(CHGVAR VAR(&ACCRX) +
                          VALUE(%SST(&SDSTAT 116 1)))                 /*S01189*/
 
/*  CALL SE2370 (UPDATE) */
 
/*           CALL       PGM(SE2370)                                 *  *E15549*/
/*           CALL       PGM(SE2370) PARM(ACCRX)      *E15549*       *  *E19833*/
             CALL       PGM(SE2370) PARM(&ACCRX)                      /*E19833*/
 
/*  DELETE OVERIDES      */
 
             DLTOVR     *ALL
 
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0606C - Job Terminated, +
                          Database in Error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
              CHGVAR    VAR(&MEM) VALUE('SEC0606C - File Controls out +
                          of Balance')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* NORMAL COMPLETION - CLEAR OUTPUT FILES */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/* CHANGE DATA AREA   TO 'NEW'          */
 
/********       CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')           /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*              CLRPFM     FILE(XDPOSND)                            *  *S01129*/
/*              CLRPFM     FILE(XDPOSNA)                            *  *S01129*/
/*              DLTF       FILE(XDPOSND)       */           /*S01129*  *S01158*/
/*                 MONMSG MSGID(CPF0000)       */           /*S01129*  *S01158*/
                RCLRSC                                                /*E15777*/
                CLRPFM     FILE(XDPOSND)                              /*S01158*/
                DLTF       FILE(XDPOSNA)                              /*S01158*/
                   MONMSG MSGID(CPF0000)                              /*S01158*/
/*/COPY WNCPYSRC,SEC0606C08                                          */
 
             ENDDO
 
/*    ENABLE ACCESS PATHS  */
 
ENDPGM:         ADDLFM   FILE(DPOSN) MBR(DPOSN)
                MONMSG  MSGID(CPF0000)
                ADDLFM   FILE(DPOSO) MBR(DPOSO)
                MONMSG  MSGID(CPF0000)
                ADDLFM   FILE(DPOSS) MBR(DPOSS)
                MONMSG  MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                ENDPGM
