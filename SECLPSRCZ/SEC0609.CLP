/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Generate A/c Keys - Accruals')               */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0609   GENERATE A/C KEYS - ACCRUALS                     */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 01Feb96              */
/*                      S01408             Date 10Jan96              */
/*                      S01408                  DATE 11MAY95        */
/*                      S01117                  DATE  08JAN91       */
/*                      S01189                  DATE  08JAN91       */
/*                      E16870                  DATE  08/03/89      */
/*                      S01129                  DATE  31/03/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hook SEC0609006                  */
/*                                      SEC0609007                  */
/*                                      SEC0609INT                  */
/*                                      SEC0609MPS                  */
/*                                      SEC0609MPE                  */
/*                                      SEC0609ERR                  */
/*       S01408 - Addition of core hook SEC0609001                  */
/*                                      SEC0609002                  */
/*                                      SEC0609003                  */
/*                                      SEC0609004                  */
/*       S01408 - Addition of core hook SEC0609MP1                   */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            */
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                    *  *E16870*/
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0609INT                                          */
                                                                      /*S01408*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/************DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
 
/************DCLDTAARA  DTAARA(SESTAT)                              *  *S01179*/
/************DCLDTAARA  DTAARA(SDSTAT)                    *  *S01129*  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)      *S01179E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*S01179*/
 
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(79)
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                * *S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0609MPS                                          */
                                                                      /*S01408*/
                                                                      /*S01129*/
/************RCVDTAARA DTAARA(SDSTAT)                     *  *S01129*  *S01179*/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)                 /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0609MP1                                          */
                                                                      /*S01408*/
 
/*  SETUP AND SEND PGM MESSAGE                                      */
 
             CHGVAR     VAR(&MSG) VALUE('SEC0609 - Generate A/C Keys +
                          - Accruals')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/*  SET OFF ALL SWITCHES                                            */
 
             CHGJOB SWS(00000000)
 
/*  CLEAR OUTPUT FILES                                              */
 
             CLRPFM     FILE(SEKEYD) MBR(ACCRUAL)
             CLRPFM     FILE(SEKEYA) MBR(ACCRUAL)
 
/*  CHECK FOR COMPONENT RESTART                                     */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)           * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  IF RESTART, DISABLE ACCESS PATHS                                */
 
/************IF         COND(&BUSY = 'NEW') THEN(DO)                 * *S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
/***************RMVM       FILE(BKPHD)    MBR(BKPHD)                */
/***************MONMSG     MSGID(CPF0000)                           */
                RMVM       FILE(BKPHV)    MBR(BKPHV)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ3V)  MBR(BKPHJ3V)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ3T)  MBR(BKPHJ3T)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ1)   MBR(BKPHJ1)
                MONMSG     MSGID(CPF0000)
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
/*/COPY WNCPYSRC,SEC0609005                                          */
 
                OVRDBF     FILE(XBKPHDD) SEQONLY(*YES 100)
 
/*  AND COPY FILES                                                  */
/*/COPY WNCPYSRC,SEC0609008                                          */
 
                CPYF       FROMFILE(XBKPHDD) TOFILE(BKPHDD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHDD)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SEC0609001                                          */
/**/                                                                  /*S01408*/
 
/*  CHANGE DATA AREA TO 'OLD'                                      */
 
/***************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')         * *S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
 
/*  ELSE BACKUP FILES                                               */
 
             ELSE       CMD(DO)
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
/*/COPY WNCPYSRC,SEC0609009                                          */
 
                OVRDBF     FILE(XBKPHDD) SEQONLY(*YES 100)
                OVRDBF     FILE(BKPHDD)  SEQONLY(*YES 100)
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
/*/COPY WNCPYSRC,SEC0609010                                          */
                DLTF       FILE(XBKPHDD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SEC0609002                                          */
/**/                                                                  /*S01408*/
 
/*  AND COPY FILES                                                 */
 
/***************CPYF       FROMFILE(BKPHDD) TOFILE(XBKPHDD) +       *  *S01129*/
/***************            MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/***************MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/***************            EXEC(CLRPFM XBKPHDD)                    *  *S01129*/
                CPYF     FROMFILE(BKPHDD) TOFILE(&TOLIB/XBKPHDD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPHDD)                      /*S01129*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SEC0609003                                          */
/**/                                                                  /*S01408*/
 
/*  DISABLE ALL ACCESS PATHS NOT USED BY RPG                        */
 
                RMVM       FILE(BKPHV)    MBR(BKPHV)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ3V)  MBR(BKPHJ3V)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ3T)  MBR(BKPHJ3T)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ1)   MBR(BKPHJ1)
                MONMSG     MSGID(CPF0000)
 
             ENDDO
 
/*  CHANGE DATA AREA TO 'NEW'                                       */
 
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')            * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  OVERRIDE FILES                                                  */
 
                OVRDBF     FILE(SEKEYD) TOFILE(SEKEYD) MBR(ACCRUAL)
                OVRDBF     FILE(SEKEYA) TOFILE(SEKEYA) MBR(ACCRUAL)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0609006                                          */
                                                                      /*S01408*/
 
/*  CALL PROGRAM                                                    */
 
             CALL       PGM(SE2210)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0609007                                          */
                                                                      /*S01408*/
 
             DLTOVR     FILE(*ALL)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0609MPE                                          */
                                                                      /*S01408*/
 
/*  FOR DATABASE ERRORS RECOVER DATA FROM LDA                       */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0609  - Job Terminated, +
                                         Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/*  FOR FILE CONTROLS OUT OF BALANCE ERROR                          */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC0609  - File Controls Out +
                                         Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/*  IF U7 AND U8 OFF                                               */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/***************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')         * *S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
/***************CLRPFM  XBKPHDD                                     *  *S01129*/
/*/COPY WNCPYSRC,SEC0609011                                          */
                DLTF       FILE(XBKPHDD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SEC0609004                                          */
/**/                                                                  /*S01408*/
             ENDDO
 
ENDPGM:      ADDLFM     FILE(BKPHJ3V)    MBR(BKPHJ3V)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(BKPHJ3T)    MBR(BKPHJ3T)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(BKPHV)      MBR(BKPHV)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(BKPHJ1)     MBR(BKPHJ1)
             MONMSG     MSGID(CPF0000)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0609END                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
