/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Gen A/c Kys+Posn Setl -Cust Mvmts')          */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0606F - TO GENERATE A/C KEYS AND POSITION SETTLEMENTS   */
/*                  FOR CUSTOMER POSITIONS WHICH HAVE NOT CHANGED   */
/*                  TODAY. + WHICH HAVE SECURITY ACTIONS DUE.       */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 233171             Date 21Apr05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 11May95              */
/*                      S01486             Date 02Dec94              */
/*                      S01117                  DATE  08JAN91       */
/*                      S01189                  DATE  08JAN91       */
/*                      E18453                  DATE  05/06/89      */
/*                      E16870                  DATE  08/03/89      */
/*                      E15777                  DATE  15/10/88      */
/*                      E14236                  DATE  09/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       233171 - Duplicate records being written to SDCSINPD       */
/*                when SEC0606F is restarted.                       */
/*       S01408 - Addition of core hook SEC0606FMS                  *  *E15549*/
/*       S01486 - Portfolio Management Upgrade to R10               */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            *  *S01189*/
/*       E18453 - FILES XMATEXD, XMATEXA AND XCPOSND SHOULD BE      *  *E18453*/
/*                CREATED AND THEN DELETED UPON SUCCESSFUL          *  *E18453*/
/*                COMPLETION OF THE PROGRAM.                        *  *E18453*/
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                    *  *E16870*/
/*       E15777 - RECLAIM RESOURCES BEFORE CLEAR OF FILE XDPOSND    *  *E15777*/
/*       E14236 - TAKE SECURITY COPY OF CPOSND                      *  *E14236*/
/*                                                                  */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(75)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                * *S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
 
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
 
/*           DCLDTAARA  DTAARA(SESTAT)                              *  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)      *S01179E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*E18453*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*E18453*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*E18453*/
/*/COPY WNCPYSRC,SEC0606F01                                          */
 
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)                 /*E18453*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*E18453*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *E18453 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0606FMS                                          */
                                                                      /*S01408*/
 
/* SETUP AND SEND PGM MESSAGE                */
 
             CHGVAR     VAR(&MSG) VALUE('SEC0606F - GENERATE A/C KEYS +
                          AND POSITION SETTLEMENTS - CUSTOMER +
                          POSITIONS')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/*/COPY WNCPYSRC,SEC0606F02                                          */
/* SET OFF SWITCHES          */
 
             CHGJOB     SWS(00000000)
 
/* CLEAR OUTPUT FILES              */
 
             CLRPFM     FILE(SEKEYD) MBR(CPOSN2)
             CLRPFM     FILE(SEKEYA) MBR(CPOSN2)
             CLRPFM     FILE(POSETD) MBR(CPOSN2)
             CLRPFM     FILE(POSETA) MBR(CPOSN2)
/*/COPY WNCPYSRC,SEC0606F03                                          */
 
/* OVERRIDE FILES                  */
 
             OVRDBF     FILE(SEKEYD) MBR(CPOSN2)
             OVRDBF     FILE(SEKEYA) MBR(CPOSN2)
             OVRDBF     FILE(POSETD) MBR(CPOSN2)
             OVRDBF     FILE(POSETA) MBR(CPOSN2)
             OVRDBF     FILE(MATEXD) MBR(CUSTOMER)
             OVRDBF     FILE(MATEXA) MBR(CUSTOMER)
/*/COPY WNCPYSRC,SEC0606F04                                          */
 
/* CHECK FOR COMPONENT RESTART                                      */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)           * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF RESTART, COPY FILES                                           */
 
/************IF COND(&BUSY = 'NEW') THEN(DO)                         * *S01189*/
             IF COND(&BUSY = 'Y') THEN(DO)                            /*S01189*/
 
             CPYF       FROMFILE(XMATEXD) TOFILE(MATEXD) +
                          FROMMBR(CUSTOMER) TOMBR(CUSTOMER) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MATEXD) MBR(CUSTOMER))
 
             CPYF       FROMFILE(XMATEXA) TOFILE(MATEXA) +
                          FROMMBR(CUSTOMER) TOMBR(CUSTOMER) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MATEXA) MBR(CUSTOMER))
             CPYF       FROMFILE(XCPOSND) TOFILE(CPOSND) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*E14236*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CPOSND))                               /*E14236*/
             CPYF       FROMFILE(XSDCSINPD) TOFILE(SDCSINPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                                  /*233171*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SDCSINPD))                                                 /*233171*/
/*/COPY WNCPYSRC,SEC0606F05                                          */
 
/* CHANGE DATA AREA                     */
 
/***************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
                CHGVAR    VAR(&BUSY) VALUE('N')                       /*S01189*/
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
 
             ENDDO
 
/*  ELSE BACKUP FILES                                               */
 
             ELSE       CMD(DO)
 
/* DELETE COPY FILES                               */                 /*E18453*/
                DLTF       FILE(XMATEXD)                              /*E18453*/
                   MONMSG MSGID(CPF0000)                              /*E18453*/
                DLTF       FILE(XMATEXA)                              /*E18453*/
                   MONMSG MSGID(CPF0000)                              /*E18453*/
                DLTF       FILE(XCPOSND)                              /*E18453*/
                   MONMSG MSGID(CPF0000)                              /*E18453*/
                DLTF       FILE(XSDCSINPD)                                                /*233171*/
                   MONMSG MSGID(CPF0000)                                                  /*233171*/
/*/COPY WNCPYSRC,SEC0606F06                                          */
 
/**********  CPYF       FROMFILE(MATEXD) TOFILE(XMATEXD) +            /*E18453*/
/**********               FROMMBR(CUSTOMER) TOMBR(CUSTOMER) +         /*E18453*/
/**********               MBROPT(*REPLACE) FMTOPT(*NONE)              /*E18453*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +  /*E18453*/
/*                        FILE(XMATEXD))                              /*E18453*/
/**********  CPYF       FROMFILE(MATEXA) TOFILE(XMATEXA) +            /*E18453*/
/**********               FROMMBR(CUSTOMER) TOMBR(CUSTOMER) +         /*E18453*/
/**********               MBROPT(*REPLACE) FMTOPT(*NONE)              /*E18453*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +  /*E18453*/
/**********               FILE(XMATEXA))                              /*E18453*/
/**********  CPYF       FROMFILE(CPOSND) TOFILE(XCPOSND) +            /*E18453*/
/**********               MBROPT(*REPLACE) FMTOPT(*NONE)              /*E18453*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +  /*E18453*/
/**********               FILE(XCPOSND))                              /*E18453*/
 
             CPYF       FROMFILE(MATEXD) TOFILE(&TOLIB/XMATEXD) +
                         FROMMBR(CUSTOMER) TOMBR(CUSTOMER) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*E18453*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XMATEXD))                              /*E18453*/
             CPYF       FROMFILE(MATEXA) TOFILE(&TOLIB/XMATEXA) +
                         FROMMBR(CUSTOMER) TOMBR(CUSTOMER) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*E18453*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XMATEXA))                              /*E18453*/
             CPYF       FROMFILE(CPOSND) TOFILE(&TOLIB/XCPOSND) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*E18453*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCPOSND))
             CPYF       FROMFILE(SDCSINPD) TOFILE(&TOLIB/XSDCSINPD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)                     /*233171*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSDCSINPD))                                                /*233171*/
/*/COPY WNCPYSRC,SEC0606F07                                          */
             ENDDO
 
/*  CHANGE DATA AREA TO 'NEW'                                       */
 
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')            * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* CALL THE PROGRAM                   */
             OVRDBF     FILE(SECET) SHARE(*NO)                        /*S01486*/
             OVRDBF     FILE(SEEVNT) TOFILE(SECED) SHARE(*NO)         /*S01486*/
 
             CALL       PGM(SE2400)
 
/* DELETE OVERRIDE                 */
 
             DLTOVR     *ALL
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA    */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (144 34)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0606F - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE IMBALANCE ERROR */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
            CHGVAR     VAR(&MEM) VALUE('SEC0606F - FILE CONTROLS OUT +
                          OF BALANCE')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             GOTO ENDPGM
             ENDDO
 
/* NORMAL COMPLETION - CLEAR OUTPUT FILES */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* CHANGE DATA AREA   TO 'OLD'          */
 
/***************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
                CHGVAR    VAR(&BUSY) VALUE('N')                       /*S01189*/
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
 
             RCLRSC                                                   /*E15777*/
/*********   CLRPFM     FILE(XMATEXD) MBR(CUSTOMER)                   /*E18453*/
/*********   CLRPFM     FILE(XMATEXA) MBR(CUSTOMER)                   /*E18453*/
/*********   CLRPFM     FILE(XCPOSND)                                 /*E18453*/
                DLTF       FILE(XMATEXD)                              /*E18453*/
                   MONMSG MSGID(CPF0000)                              /*E18453*/
                DLTF       FILE(XMATEXA)                              /*E18453*/
                   MONMSG MSGID(CPF0000)                              /*E18453*/
                DLTF       FILE(XCPOSND)                              /*E18453*/
                   MONMSG MSGID(CPF0000)                              /*E18453*/
                DLTF       FILE(XSDCSINPD)                                                /*233171*/
                   MONMSG MSGID(CPF0000)                                                  /*233171*/
/*/COPY WNCPYSRC,SEC0606F08                                          */
 
                ENDDO
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
