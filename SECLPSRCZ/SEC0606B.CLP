/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Update Customer Depot Positions')            */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0606B - UPDATE PAST & CURRENT CUST. DEPOT POSITIONS     */
/*                  WITH THE EFFECT OF TRADES,DEPOT MOVEMENTS       */
/*                  AND TRADE SETTLEMENTS                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408                  DATE 11MAY95        */
/*       PREV AMEND NO. S01117                  DATE  08JAN91       */
/*                      S01189                  DATE  08JAN91       */
/*                      E16870                  DATE  08/03/89      */
/*                      S01129                  DATE  31/03/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       S01408 - Addition of core hook SEC0606BMS                   */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            *   S01189*/
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                    *  *E16870*/
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/********    PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
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
 
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/*           DCLDTAARA  DTAARA(SESTAT)                              *  *S01179*/
/*           DCLDTAARA  DTAARA(SDSTAT)                    *  *S01129*  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)      *S01179E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*S01179*/
/*/COPY WNCPYSRC,SEC0606B01                                          */
                                                                      /*S01129*/
/*           RCVDTAARA DTAARA(SDSTAT)                     *  *S01129*  *S01179*/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)                 /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0606BMS                                          */
                                                                      /*S01408*/
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0606B - Update Customer +
                          Depot Positions')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* CHECK FOR COMPONENT RESTART                                      */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF RESTART DISABLE RELATED ACCESS PATHS                          */
 
/********    IF COND(&BUSY = 'NEW') THEN(DO)                          /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
                RMVM       FILE(CDEPP) MBR(CDEPP)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(CDEPZ) MBR(CDEPZ)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(CDEPS) MBR(CDEPS)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(CUDEP) MBR(CUDEP)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(CUDPS) MBR(CUDPS)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(CUDPB) MBR(CUDPB)
                MONMSG MSGID(CPF0000)
 
/* OVERRIDE FILES                       */
 
                OVRDBF FILE(CDEPPD)  SEQONLY(*YES 100)
                OVRDBF FILE(CDEPPA)  SEQONLY(*YES 1)
                OVRDBF FILE(XCDEPPD) SEQONLY(*YES 100)
                OVRDBF FILE(XCDEPPA) SEQONLY(*YES 1)
 
/* AND COPY FILES                       */
 
                CPYF FROMFILE(XCDEPPD) TOFILE(CDEPPD) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CDEPPD)
 
                CPYF FROMFILE(XCDEPPA) TOFILE(CDEPPA) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CDEPPA)
 
/* CHANGE DATA AREA                     */
 
/********       CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')           /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
 
/*   SAVE TO BE UPDATED FILES TO X(filename)                        */
 
             OVRDBF FILE(CDEPPD) SEQONLY(*YES 100)
             OVRDBF FILE(CDEPPA) SEQONLY(*YES 1)
             OVRDBF FILE(XCDEPPD) SEQONLY(*YES 100)
             OVRDBF FILE(XCDEPPA) SEQONLY(*YES 1)
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XCDEPPD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCDEPPA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
 
/*           CPYF FROMFILE(CDEPPD) TOFILE(XCDEPPD) +                *  *S01129*/
/*           MBROPT(*REPLACE) FMTOPT(*NONE)                         *  *S01129*/
/*           MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +                *  *S01129*/
/*           EXEC(CLRPFM XCDEPPD)                                   *  *S01129*/
/*                                                                  *  *S01129*/
/*           CPYF FROMFILE(CDEPPA) TOFILE(XCDEPPA) +                *  *S01129*/
/*           MBROPT(*REPLACE) FMTOPT(*NONE)                         *  *S01129*/
/*           MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +                *  *S01129*/
/*           EXEC(CLRPFM XCDEPPA)                                   *  *S01129*/
             CPYF FROMFILE(CDEPPD) TOFILE(&TOLIB/XCDEPPD) +
             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)             /*S01129*/
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XCDEPPD)                                     /*S01129*/
                                                                      /*S01129*/
             CPYF FROMFILE(CDEPPA) TOFILE(&TOLIB/XCDEPPA) +
             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)             /*S01129*/
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XCDEPPA)                                     /*S01129*/
 
/* CHANGE DATA AREA   TO 'NEW'          */
 
/********    CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('NEW')              /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*   DISABLE ACCESS PATHS FOR LOGICALS NOT REQUIRED BY THIS RPG     */
 
                RMVM       FILE(CDEPP) MBR(CDEPP)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(CDEPZ) MBR(CDEPZ)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(CDEPS) MBR(CDEPS)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(CUDEP) MBR(CUDEP)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(CUDPS) MBR(CUDPS)
                MONMSG MSGID(CPF0000)
                RMVM       FILE(CUDPB) MBR(CUDPB)
                MONMSG MSGID(CPF0000)
 
/*  CALL SE2360 (UPDATE) */
 
             CALL       PGM(SE2360)
 
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RCVDTAARA  DTAARA(LDA) ******************************  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0606B - Job Terminated, +
                          Database in Error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
              CHGVAR    VAR(&MEM) VALUE('SEC0606B - File Controls out +
                          of Balance')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* NORMAL COMPLETION - CLEAR OUTPUT FILES */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/* CHANGE DATA AREA   TO 'NEW'          */
 
/********       CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')           /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
/*              CLRPFM     FILE(XCDEPPD)                            */
/*              CLRPFM     FILE(XCDEPPA)                            */
                DLTF       FILE(XCDEPPD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCDEPPA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
 
             ENDDO
 
/*    ENABLE ACCESS PATHS  */
 
ENDPGM:         ADDLFM   FILE(CDEPP) MBR(CDEPP)
                MONMSG  MSGID(CPF0000)
                ADDLFM   FILE(CUDEP) MBR(CUDEP)
                MONMSG  MSGID(CPF0000)
                ADDLFM   FILE(CDEPZ) MBR(CDEPZ)
                MONMSG  MSGID(CPF0000)
                ADDLFM   FILE(CDEPS) MBR(CDEPS)
                MONMSG  MSGID(CPF0000)
                ADDLFM   FILE(CUDPB) MBR(CUDPB)
                MONMSG  MSGID(CPF0000)
                ADDLFM   FILE(CUDPS) MBR(CUDPS)
                MONMSG  MSGID(CPF0000)
/*/COPY WNCPYSRC,SEC0606B02                                          */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                ENDPGM
