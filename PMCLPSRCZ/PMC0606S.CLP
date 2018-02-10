/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Update User & Customer Depot Positions')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0606S - UPDATE USER AND CUSTOMER DEPOT POSITIONS         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 11May95              */
/*                      S01486             Date 17Jun94              */
/*                      S01189             DATE 10APR92              */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hook PMC0606SM1                   */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2             */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                        S01189*/
             PGM        PARM(&ACCRX &CNAM &CSEQ)                      /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
 
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                   S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
/*********** DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                   S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ACCRX) TYPE(*CHAR) LEN(1)                /*S01189*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
/********    DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)            S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
                MONMSG MSGID(CPF2817)
 
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')             S01486*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC0606SM1                                          */
                                                                      /*S01408*/
 
 
/* SEND PGM MESSAGE */
 
/*********** CHGVAR     VAR(&MEM) VALUE('SEC0606S (1) - UPDATE USER +
                          DEPOT POSITIONS')                             S01486*/
             CHGVAR     VAR(&MEM) VALUE('PMC0606S (1) - UPDATE USER +
                          DEPOT POSITIONS')                           /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
 
/* CHECK FOR COMPONENT RESTART                                      */
 
/**********  RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)             S01189*/
 
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/* OVERRIDE FILES                       */
 
                OVRDBF FILE(UDEPPD)  SEQONLY(*YES 100)
                OVRDBF FILE(CDEPPD)  SEQONLY(*YES 100)
 
                OVRDBF FILE(XCDEPPD) SEQONLY(*YES 100)
                OVRDBF FILE(XUDEPPD) SEQONLY(*YES 100)
 
/* IF RESTART                                                       */
 
/*********** IF COND(&BUSY = 'NEW') THEN(DO)                            S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
/* RESTORE FILES                          */
 
                CPYF FROMFILE(XUDEPPD) TOFILE(UDEPPD) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM UDEPPD)
 
                CPYF FROMFILE(XUDEPPA) TOFILE(UDEPPA) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM UDEPPA)
 
                CPYF FROMFILE(XCDEPPD) TOFILE(CDEPPD) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CDEPPD)
 
                CPYF FROMFILE(XCDEPPA) TOFILE(CDEPPA) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CDEPPA)
 
/* CHANGE DATA AREA                     */
 
/********       CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')             S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
 
/* DELETE COPY FILES                               */
 
                DLTF       FILE(XUDEPPD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XUDEPPA)
                   MONMSG MSGID(CPF0000)
 
                DLTF       FILE(XCDEPPD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XCDEPPA)
                   MONMSG MSGID(CPF0000)
 
/*   SAVE TO BE UPDATED FILES TO X(filename)                        */
 
             CPYF FROMFILE(UDEPPD) TOFILE(&TOLIB/XUDEPPD) +
             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XUDEPPD)
 
             CPYF FROMFILE(UDEPPA) TOFILE(&TOLIB/XUDEPPA) +
             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XUDEPPA)
 
             CPYF FROMFILE(CDEPPD) TOFILE(&TOLIB/XCDEPPD) +
             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XCDEPPD)
 
             CPYF FROMFILE(CDEPPA) TOFILE(&TOLIB/XCDEPPA) +
             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XCDEPPA)
 
/* CHANGE DATA AREA   TO 'NEW'          */
 
/*********   CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('NEW')                S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  CALL SE2350 (UPDATE) */
 
             CALL       PGM(SE2350)
 
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/*********** CHGVAR    VAR(&MEM) VALUE('SEC0606S (1) - JOB TERMINATED,+
                          DATABASE IN ERROR')                           S01486*/
             CHGVAR    VAR(&MEM) VALUE('PMC0606S (1) - JOB TERMINATED,+
                          DATABASE IN ERROR')                         /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/************ CHGVAR    VAR(&MEM) VALUE('SEC0606S (1) - FILE CONTROLS +
                          OUT OF BALANCE')                              S01486*/
              CHGVAR    VAR(&MEM) VALUE('PMC0606S (1) - FILE CONTROLS +
                          OUT OF BALANCE')                            /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* SEND PGM MESSAGE */
 
/*********** CHGVAR     VAR(&MEM) VALUE('SEC0606S (2) - UPDATE +
                          CUSTOMER DEPOT POSNS')                        S01486*/
             CHGVAR     VAR(&MEM) VALUE('PMC0606S (2) - UPDATE +
                          CUSTOMER DEPOT POSNS')                      /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/*  CALL SE2360 (UPDATE) */
 
             CALL       PGM(SE2360)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/*********** CHGVAR    VAR(&MEM) VALUE('SEC0606S (2) - JOB TERMINATED,+
                          DATABASE IN ERROR')                           S01486*/
             CHGVAR    VAR(&MEM) VALUE('PMC0606S (2) - JOB TERMINATED,+
                          DATABASE IN ERROR')                         /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/************ CHGVAR    VAR(&MEM) VALUE('SEC0606S (2) - FILE CONTROLS +
                          OUT OF BALANCE')                            /*S01486*/
              CHGVAR    VAR(&MEM) VALUE('PMC0606S (2) - FILE CONTROLS +
                          OUT OF BALANCE')                            /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* SEND PGM MESSAGE */
 
/*********** CHGVAR     VAR(&MEM) VALUE('SEC0606S (3) - MATURE +
                          USER/CUST.DEPOT POSNS')                       S01486*/
             CHGVAR     VAR(&MEM) VALUE('PMC0606S (3) - MATURE +
                          USER/CUST.DEPOT POSNS')                     /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/*  CALL SE2365 (UPDATE) */
 
             CALL       PGM(SE2365)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/*********** CHGVAR    VAR(&MEM) VALUE('SEC0606S (3) - JOB TERMINATED,+
                          DATABASE IN ERROR')                           S01486*/
             CHGVAR    VAR(&MEM) VALUE('PMC0606S (3) - JOB TERMINATED,+
                          DATABASE IN ERROR')                         /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             GOTO ENDPGM
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/*********** CHGVAR    VAR(&MEM) VALUE('SEC0606S (3) - FILE CONTROLS +
                        OUT OF BALANCE')                                S01486*/
             CHGVAR    VAR(&MEM) VALUE('PMC0606S (3) - FILE CONTROLS +
                        OUT OF BALANCE')                              /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             GOTO ENDPGM
             ENDDO
 
/* CHANGE DATA AREA   TO 'OLD'          */
 
/********    CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')                S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
             DLTF       FILE(XUDEPPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(XUDEPPA)
             MONMSG MSGID(CPF0000)
 
             DLTF       FILE(XCDEPPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(XCDEPPA)
             MONMSG MSGID(CPF0000)
 
ENDPGM:                                                               /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/****ENDPGM:      ENDPGM                                                S01486*/
                ENDPGM                                                /*S01486*/
