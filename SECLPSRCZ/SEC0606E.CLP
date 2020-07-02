/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Gen A/c Kys+Posn Setl-Depot Mvmts')          */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0606E - TO GENERATE A/C KEYS AND POSITION SETTLEMENTS   */
/*                  FOR DEPOT POSITIONS WHICH HAVE NOT CHANGED      */
/*                  TODAY. + WHICH HAVE SECURITY ACTIONS DUE.       */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. DUG502             Date 07Dec17              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG11616           Date 28Jun06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117             Date 08Jan91              */
/*                      E15777             Date 15Oct88              */
/*                      E15778                  DATE  15/10/88      */
/*                      E14236                  DATE  09/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       DUG502 - Security Diary Enhancements.                       */
/*                Add Hook DUG502_228                                */
/*                Amend Hook SEC0606E01                              */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG11616 - SEC0606E 00001 failed, field DDPT would not     */
/*                  map from file DPOSND.                           */
/*       S01117 - MULTIBRANCHING                                    */
/*       E15777 - RECLAIM RESOURCES BEFORE CLEAR OF FILE XDPOSND    *  *E15777*/
/*       E15778 - SET UP &BUSY FROM SESTAT                          *  *E15778*/
/*       E14236 - TAKE SECURITY COPY OF DPOSND                      *  *E14236*/
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
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(65)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)         *E14236* *S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
 
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/*/COPY WNCPYSRC,SEC0606E01                                          */                   /*DUG502*/
 
/* SETUP AND SEND PGM MESSAGE                */
 
             CHGVAR     VAR(&MSG) VALUE('SEC0606E - GENERATE A/C KEYS +
                          AND POSITION SETTLEMENTS - DEPOT POSITIONS')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/*/COPY WNCPYSRC,SEC0606E02                                          */
/* SET OFF SWITCHES          */
 
             CHGJOB     SWS(00000000)
 
/* OVERRIDE FILES                  */
 
             OVRDBF     FILE(SEKEYD) MBR(DPOSN2)
             OVRDBF     FILE(SEKEYA) MBR(DPOSN2)
             OVRDBF     FILE(POSETD) MBR(DPOSN2)
             OVRDBF     FILE(POSETA) MBR(DPOSN2)
/*/COPY WNCPYSRC,SEC0606E03                                          */
 
/* CLEAR OUTPUT FILES              */
 
             CLRPFM     FILE(SEKEYD) MBR(DPOSN2)
             CLRPFM     FILE(SEKEYA) MBR(DPOSN2)
             CLRPFM     FILE(POSETD) MBR(DPOSN2)
             CLRPFM     FILE(POSETA) MBR(DPOSN2)
/*/COPY WNCPYSRC,SEC0606E04                                          */
/* CHECK FOR COMPONENT RESTART                                      *  *E15778*/
                                                                      /*E15778*/
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)    *E15778* *S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
                                                                      /*E15778*/
 
/* IF RESTART, TAKE SECURITY COPY OF DPOSND                  START--*  *E14236*/
 
/************IF         COND(&BUSY = 'NEW') THEN(DO)                 * *S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
/**********  CPYF       FROMFILE(XDPOSND) TOFILE(DPOSND)  +  */                         /*BUG11616*/
/**********               MBROPT(*REPLACE) FMTOPT(*NONE)     */                         /*BUG11616*/
             CPYF       FROMFILE(XDPOSND) TOFILE(DPOSND)  +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)                               /*BUG11616*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(DPOSND))
/*/COPY WNCPYSRC,SEC0606E05                                          */
 
/* CHANGE DATA AREA TO 'OLD'           */
 
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')            * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
             ENDDO
 
/* BACKUP FILE                         */
 
/**********  CPYF       FROMFILE(DPOSND) TOFILE(XDPOSND)  +  */                         /*BUG11616*/
/**********               MBROPT(*REPLACE) FMTOPT(*NONE)     */                         /*BUG11616*/
             CPYF       FROMFILE(DPOSND) TOFILE(XDPOSND)  +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)                               /*BUG11616*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(XDPOSND))
/*/COPY WNCPYSRC,SEC0606E06                                          */
 
/* CHANGE DATA AREA TO 'NEW'           */
 
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')            * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/*                                                           END----*  *E14236*/
/* CALL THE PROGRAM                   */
 
             CALL       PGM(SE2390)
/*/COPY WNCPYSRC,DUG502_228                                          */                   /*DUG502*/
 
/* DELETE OVERRIDE                    */
 
             DLTOVR     *ALL
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA    */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (144 34)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0606E - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE IMBALANCE ERROR */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
            CHGVAR     VAR(&MEM) VALUE('SEC0606E - FILE CONTROLS OUT +
                          OF BALANCE')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM                                           /*E14236*/
             ENDDO
 
/* CHANGE DATA AREA TO 'OLD'           */
 
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')            * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/* CLEAR FILE                         */
 
             RCLRSC                                                   /*E14777*/
             CLRPFM     FILE(XDPOSND)                                 /*E14236*/
/*/COPY WNCPYSRC,SEC0606E07                                          */
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
