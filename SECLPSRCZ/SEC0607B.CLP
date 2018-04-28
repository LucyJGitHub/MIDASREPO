/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Generate A/c Keys-Contingent Liab')          */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0607B - GENERATE A/C KEYS - CONTINGENT LIABILITIES      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408                  DATE 11MAY95        */
/*       PREV AMEND NO. S01117                  DATE  08JAN91       */
/*                      S01189                  DATE  08JAN91       */
/*                      E16870                  DATE  08/03/89      */
/*                      S01129                  DATE  31/03/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       S01408 - Addition of core hook SEC0607BM1                   */
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
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
 
/*           DCLDTAARA  DTAARA(SESTAT)                              *  *S01179*/
/*           DCLDTAARA  DTAARA(SDSTAT)                    *  *S01129*  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)      *S01179E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
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
/*/COPY WNCPYSRC,SEC0607BM1                                          */
                                                                      /*S01408*/
 
/*  SETUP AND SEND PGM MESSAGE                                      */
 
             CHGVAR     VAR(&MSG) VALUE('SEC0607B - Generate A/C Keys +
                          - Contingent Liabilities')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/*  SET OFF ALL SWITCHES                                            */
 
             CHGJOB SWS(00000000)
 
/*  CLEAR OUTPUT FILES                                              */
 
             CLRPFM     FILE(SEKEYD) MBR(CONTLIAB)
             CLRPFM     FILE(SEKEYA) MBR(CONTLIAB)
 
/*  CHECK FOR COMPONENT RESTART                                     */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)           * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  IF RESTART, DISABLE ACCESS PATHS                                */
 
/************IF         COND(&BUSY = 'NEW') THEN(DO)                 * *S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
/*              RMVM       FILE(CLIAB)    MBR(CLIAB)                */
/*              MONMSG     MSGID(CPF0000)                           */
                RMVM       FILE(CLBTR)    MBR(CLBTR)
                MONMSG     MSGID(CPF0000)
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
 
                OVRDBF     FILE(XCLIABD) SEQONLY(*YES 100)
                OVRDBF     FILE(XCLIABA) SEQONLY(*YES 100)
                OVRDBF     FILE(CLIABD)  SEQONLY(*YES 100)
                OVRDBF     FILE(CLIABA)  SEQONLY(*YES 100)
 
/*  AND COPY FILES                                                  */
 
                CPYF       FROMFILE(XCLIABD) TOFILE(CLIABD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CLIABD)
                CPYF       FROMFILE(XCLIABA) TOFILE(CLIABA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CLIABA)
 
/*  CHANGE DATA AREA TO 'OLD'                                      */
 
/***************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')         * *S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
 
/*  ELSE BACKUP FILES                                               */
 
             ELSE       CMD(DO)
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
 
                OVRDBF     FILE(CLIABD)  SEQONLY(*YES 100)
                OVRDBF     FILE(CLIABA)  SEQONLY(*YES 100)
                OVRDBF     FILE(XCLIABD) SEQONLY(*YES 100)
                OVRDBF     FILE(XCLIABA) SEQONLY(*YES 100)
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XCLIABD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCLIABA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
 
/*  AND COPY FILES                                                 */
/*                                                                  *  *S01129*/
/*              CPYF       FROMFILE(CLIABD) TOFILE(XCLIABD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XCLIABD)                    *  *S01129*/
/*              CPYF       FROMFILE(CLIABA) TOFILE(XCLIABA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XCLIABA)                    *  *S01129*/
                CPYF     FROMFILE(CLIABD) TOFILE(&TOLIB/XCLIABD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG   (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM XCLIABD)                        /*S01129*/
                CPYF     FROMFILE(CLIABA) TOFILE(&TOLIB/XCLIABA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG   (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM XCLIABA)                        /*S01129*/
 
             ENDDO
 
/*  CHANGE DATA AREA TO 'NEW'                                       */
 
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')            * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  OVERRIDE FILES                                                  */
 
                OVRDBF     FILE(SEKEYD) TOFILE(SEKEYD) MBR(CONTLIAB)
                OVRDBF     FILE(SEKEYA) TOFILE(SEKEYA) MBR(CONTLIAB)
 
/*  CALL PROGRAM                                                    */
 
             CALL       PGM(SE2420)
 
             DLTOVR     FILE(*ALL)
 
/*  FOR DATABASE ERRORS RECOVER DATA FROM LDA                       */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0607B - Job Terminated, +
                                         Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/*  FOR FILE CONTROLS OUT OF BALANCE ERROR                          */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC0607B - File Controls Out +
                                         Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/*  IF U7 AND U8 OFF, CHANGE SESTAT TO "OLD"                       */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/**************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
               CHGVAR     VAR(&BUSY) VALUE('N')                       /*S01189*/
               CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
 
/**********  CLEAR FILES                                            *  *S01129*/
/*                                                                  *  *S01129*/
/*             CLRPFM     FILE(XCLIABD)                             *  *S01129*/
/*             CLRPFM     FILE(XCLIABA)                             *  *S01129*/
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XCLIABD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCLIABA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
 
             ENDDO
 
ENDPGM:      ADDLFM     FILE(CLBTR)    MBR(CLBTR)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
