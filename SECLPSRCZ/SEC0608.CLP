/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Mk. Mkt Reval Date Check & Update')          */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/********SEC0608***GENERATE*A/C*KEYS*-*MARK*TO*MARKET*REVALUATION****  *E15965*/
/*       SEC0608   MARK TO MARKET REVALUATION DATE CHECK (& UPDATE) *  *E15965*/
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01117                  DATE  24JAN91       */
/*       PREV AMEND NO. E23186                  DATE  03AUG90       */
/*                      S01179                  DATE  16/12/88      */
/*                      E15965                  DATE  31/10/88      */
/*                      S01129                  DATE  31/03/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       S01117 - MULTIBRANCHING                                    */
/*       E23186 - PGM SHOULD CALL SE2285, SO THAT SYNON FILE IS     */
/*                UPDATED, INSTEAD OF SE2282.                       */
/*       S01179 - AS400 CHANGES TO COMMANDS                         */
/*       E15965 - MARK TO MARKET REVALUATION                        */
/*       S01129 - SE II INCORPORATION                               */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(79)
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
/*           DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)               * *E15965*/
/*           DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)  *  *S01129* *E15965*/
/*           DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)      *  *S01129* *E15965*/
 
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)          * *E15965*/
/*           DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)*  *S01129* *E15965*/
 
/*           DCLF       FILE(BKRVLD)                                *  *E15965*/
                                                                      /*S01129*/
/*           RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)      * *S01129*  *E15965*/
/*           CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))  * *S01129*  *E15965*/
/*           CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')* *S01129*  *E15965*/
 
/*  SETUP AND SEND PGM MESSAGE                                      */
 
/*           CHGVAR     VAR(&MSG) VALUE('SEC0608 - Generate A/C Keys +**E15965*/
/*                           - Market Revaluation')                   **E15965*/
             CHGVAR     VAR(&MSG) VALUE('SEC0608 - Check Mark to +
                          Market Revaluation date')                   /*E15965*/
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/*  SET OFF ALL SWITCHES                                            */
 
             CHGJOB SWS(00000000)
 
/*  CALL PGM.                                                       */
 
                                                                    /*E23186*/
/**********  CALL   PGM(SE2282)                                 *****/
             CALL   PGM(SE2285)
                                                                    /*E23186*/
 
/*  FOR DATABASE ERRORS RECOVER DATA FROM LDA                       */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0608  - Job Terminated, +
                                         Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/*  FOR FILE CONTROLS OUT OF BALANCE ERROR                          */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC0608  - File Controls Out +
                                         Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
             CLRPFM     FILE(BKRVLD)                                  /*E15965*/
/*  IF SWITCH 1 OFF,CHECK IF ANY REQUESTS ARE DUE                   */
/*                                                                  *  *E15965*/
/*          IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)             *  *E15965*/
/*                                                                  *  *E15965*/
/*  DETERMINE IF BKRVLD FILE IS EMPTY                               *  *E15965*/
/*                                                                  *  *E15965*/
/*             CHGJOB SWS(11000000)                                 *  *E15965*/
/*                                                                  *  *E15965*/
/*           OVRDBF     FILE(BKRVLD) SHARE(*NO)                     *  *E15965*/
/*           RCVF                                                   *  *E15965*/
/*           MONMSG     MSGID(CPF0864) EXEC(CHGJOB SWS(00000000))   *  *E15965*/
/*                                                                  *  *E15965*/
/*           ENDDO                                                  *  *E15965*/
/*                                                                  *  *E15965*/
/*  IF SWITCH 1 ON, CONTINUE PROCESSING                             */
/*                                                                  *  *E15965*/
/*          IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)             *  *E15965*/
/*                                                                  *  *E15965*/
/*  SETUP AND SEND PGM MESSAGE                                      */
/*                                                                  *  *E15965*/
/*           CHGVAR     VAR(&MSG) VALUE('SEC0608 - Generate A/c Keys*  *E15965*/
/*                        - Mark to Market Revaluation')            *  *E15965*/
/*                                                                  *  *E15965*/
/*           SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)      *  *E15965*/
/*                                                                  *  *E15965*/
/*  CLEAR OUTPUT FILES                                              */
/*                                                                  *  *E15965*/
/*           CLRPFM     FILE(SEKEYD) MBR(MMREVAL)                   *  *E15965*/
/*           CLRPFM     FILE(SEKEYA) MBR(MMREVAL)                   *  *E15965*/
/*                                                                  *  *E15965*/
/*  CHECK FOR COMPONENT RESTART                                     */
/*                                                                  *  *E15965*/
/*           RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)          *  *E15965*/
/*                                                                  *  *E15965*/
/*  IF RESTART, DISABLE ACCESS PATHS                                */
/*                                                                  *  *E15965*/
/*           IF         COND(&BUSY = 'NEW') THEN(DO)                *  *E15965*/
/*                                                                  *  *E15965*/
/*              RMVM       FILE(BKPHD)    MBR(BKPHD)                */
/*              MONMSG     MSGID(CPF0000)                           */
/*              RMVM       FILE(BKPHV)    MBR(BKPHV)                *  *E15965*/
/*              MONMSG     MSGID(CPF0000)                           *  *E15965*/
/*              RMVM       FILE(BKPHJ3V)  MBR(BKPHJ3V)              *  *E15965*/
/*              MONMSG     MSGID(CPF0000)                           *  *E15965*/
/*              RMVM       FILE(BKPHJ3T)  MBR(BKPHJ3T)              *  *E15965*/
/*              MONMSG     MSGID(CPF0000)                           *  *E15965*/
/*              RMVM       FILE(BKPHJ1)   MBR(BKPHJ1)               */
/*              MONMSG     MSGID(CPF0000)                           */
/*              RMVM       FILE(BKPOS)    MBR(BKPOS)                */
/*              MONMSG     MSGID(CPF0000)                           */
/*                                                                  *  *E15965*/
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
/*                                                                  *  *E15965*/
/*              OVRDBF     FILE(XBKPHDD) SEQONLY(*YES 100)          *  *E15965*/
/*              OVRDBF     FILE(XTABTB36) SEQONLY(*YES 100)         *  *E15965*/
/*                                                                  *  *E15965*/
/*  AND COPY FILES                                                  */
/*                                                                  *  *E15965*/
/*              CPYF       FROMFILE(XBKPHDD) TOFILE(BKPHDD) +       *  *E15965*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *E15965*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *E15965*/
/*                          EXEC(CLRPFM BKPHDD)                     *  *E15965*/
/*              CPYF       FROMFILE(XTABTB36) TOFILE(TABTB36) +     *  *E15965*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *E15965*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *E15965*/
/*                          EXEC(CLRPFM TABTB36)                    *  *E15965*/
/*                                                                  *  *E15965*/
/*  CHANGE DATA AREA TO 'OLD'                                       */
/*                                                                  *  *E15965*/
/*              CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')        *  *E15965*/
/*                                                                  *  *E15965*/
/*           ENDDO                                                  *  *E15965*/
/*                                                                  *  *E15965*/
/*  ELSE BACKUP FILES                                               */
/*                                                                  *  *E15965*/
/*           ELSE       CMD(DO)                                     *  *E15965*/
/*                                                                  *  *E15965*/
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
/*                                                                  *  *E15965*/
/*              OVRDBF     FILE(XBKPHDD) SEQONLY(*YES 100)          *  *E15965*/
/*              OVRDBF     FILE(XTABTB36) SEQONLY(*YES 100)         *  *E15965*/
/*              OVRDBF     FILE(BKPHDD)  SEQONLY(*YES 100)          *  *E15965*/
/*              OVRDBF     FILE(TABTB36)  SEQONLY(*YES 100)         *  *E15965*/
/*                                                        *  *S01129*  *E15965*/
                                                                      /*S01129*/
/* DELETE COPY FILES                                      *  *S01129*  *E15965*/
/*                                                        *  *S01129*  *E15965*/
/*              DLTF       FILE(XBKPHDD)                  *  *S01129*  *E15965*/
/*                 MONMSG MSGID(CPF0000)                  *  *S01129*  *E15965*/
/*              DLTF       FILE(XTABTB36)                 *  *S01129*  *E15965*/
/*                 MONMSG MSGID(CPF0000)                  *  *S01129*  *E15965*/
/*                                                                  *  *E15965*/
/*  AND COPY FILES                                                  */
/*                                                                  *  *E15965*/
/*              CPYF       FROMFILE(BKPHDD) TOFILE(XBKPHDD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XBKPHDD)                    *  *S01129*/
/*              CPYF       FROMFILE(TABTB36) TOFILE(XTABTB36) +     *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XTABTB36)                   *  *S01129*/
/*              CPYF       FROMFILE(BKPHDD) TOFILE(XBKPHDD.&TOLIB) +*  *E15965*/
/*                       MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES*  *E15965*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *E15965*/
/*                          EXEC(CLRPFM XBKPHDD)                    *  *E15965*/
/*              CPYF       FROMFILE(TABTB36) TOFILE(XTABTB36.&TOLIB)*  *E15965*/
/*                       MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES*  *E15965*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *E15965*/
/*                          EXEC(CLRPFM XTABTB36)                   *  *E15965*/
/*                                                                  *  *E15965*/
/*  DISABLE ALL ACCESS PATHS NOT USED BY RPG                        */
/*                                                                  *  *E15965*/
/*              RMVM       FILE(BKPHV)    MBR(BKPHV)                *  *E15965*/
/*              MONMSG     MSGID(CPF0000)                           *  *E15965*/
/*              RMVM       FILE(BKPHJ3V)  MBR(BKPHJ3V)              *  *E15965*/
/*              MONMSG     MSGID(CPF0000)                           *  *E15965*/
/*              RMVM       FILE(BKPHJ3T)  MBR(BKPHJ3T)              *  *E15965*/
/*              MONMSG     MSGID(CPF0000)                           *  *E15965*/
/*              RMVM       FILE(BKPHJ1)   MBR(BKPHJ1)               */
/*              MONMSG     MSGID(CPF0000)                           */
/*                                                                  *  *E15965*/
/*           ENDDO                                                  *  *E15965*/
/*                                                                  *  *E15965*/
/*  CHANGE DATA AREA TO 'NEW'                                       */
/*                                                                  *  *E15965*/
/*           CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')           *  *E15965*/
/*                                                                  *  *E15965*/
/*  OVERRIDE FILES                                                  */
/*                                                                  *  *E15965*/
/*              OVRDBF     FILE(SEKEYD) TOFILE(SEKEYD) MBR(MMREVAL) *  *E15965*/
/*              OVRDBF     FILE(SEKEYA) TOFILE(SEKEYA) MBR(MMREVAL) *  *E15965*/
/*                                                                  *  *E15965*/
/*  CALL PROGRAM                                                    */
/*                                                                  *  *E15965*/
/*           CALL       PGM(SE2280)                                 *  *E15965*/
/*                                                                  *  *E15965*/
/*           DLTOVR     FILE(*ALL)                                  *  *E15965*/
/*                                                                  *  *E15965*/
/*  FOR DATABASE ERRORS RECOVER DATA FROM LDA                       */
/*                                                                  *  *E15965*/
/*RROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)            *  *E15965*/
/*              RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)        *  *E15965*/
/*              SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)- *  *E15965*/
/*                         TOMSGQ(MOPERQ MRUNQ)                     *  *E15965*/
/*              CHGVAR    VAR(&MEM) VALUE('SEC0608  - Job Terminated*  *E15965*/
/*                                       Database in Error')        *  *E15965*/
/*              SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)           *  *E15965*/
/*              GOTO ENAB                                           *  *E15965*/
/*           ENDDO                                                  *  *E15965*/
/*                                                                  *  *E15965*/
/*  FOR FILE CONTROLS OUT OF BALANCE ERROR                          */
/*                                                                  *  *E15965*/
/*           IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)            *  *E15965*/
/*              CHGVAR  VAR(&MEM) VALUE('SEC0608  - File Controls Ou*  *E15965*/
/*                                       Of Balance')               *  *E15965*/
/*              SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)           *  *E15965*/
/*              GOTO ENAB                                           *  *E15965*/
/*           ENDDO                                                  *  *E15965*/
/*                                                                  *  *E15965*/
/*  IF U7 AND U8 OFF                                                */
/*                                                                  *  *E15965*/
/*           IF         COND(%SWITCH(XXXXXX00)) THEN(DO)            *  *E15965*/
/*              CALL    PGM(SE2285)                                 *  *E15965*/
/*              CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')        *  *E15965*/
/*              CLRPFM  XBKPHDD                                    *   *S01129*/
/*              DLTF       FILE(XBKPHDD)                  *  *S01129*  *E15965*/
/*                 MONMSG MSGID(CPF0000)                  *  *S01129*  *E15965*/
/*              DLTF       FILE(XTABTB36)                 *  *S01129*  *E15965*/
/*                 MONMSG MSGID(CPF0000)                  *  *S01129*  *E15965*/
/*           ENDDO                                                  *  *E15965*/
/*                                                                  *  *E15965*/
/**B:        ADDLFM     FILE(BKPHJ3V)    MBR(BKPHJ3V)               *  *E15965*/
/*           MONMSG     MSGID(CPF0000)                              *  *E15965*/
/*           ADDLFM     FILE(BKPHJ3T)    MBR(BKPHJ3T)               *  *E15965*/
/*           MONMSG     MSGID(CPF0000)                              *  *E15965*/
/*           ADDLFM     FILE(BKPHV)      MBR(BKPHV)                 *  *E15965*/
/*           MONMSG     MSGID(CPF0000)                              *  *E15965*/
/*           ADDLFM     FILE(BKPHJ1)     MBR(BKPHJ1)                */
/*           MONMSG     MSGID(CPF0000)                              */
/*                                                                  *  *E15965*/
/*          ENDDO                                                   *  *E15965*/
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
