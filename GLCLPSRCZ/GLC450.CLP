/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Journal posting')                            */
/********************************************************************/
/*                                                                  */
/*        Midas GENERAL LEDGER MODULE                               */
/*                                                                  */
/*        GLC450 - REAL TIME POSTINGS                               */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. MD023889           Date 10Dic13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. 191263             Date 03May01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      110361             DATE  21JAN97            */
/*                      CMC001             DATE  18MAR96            */
/*                      090139             DATE  28JUN96            */
/*                      S01408             DATE  14JUN95            */
/*                      087618             DATE  08JUN95            */
/*                      047264             DATE  11NOV92            */
/*                      048237             DATE  09FEB93            */
/*                      S10736             DATE  12NOV92            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD023889 - Accounting Rules Process (GL Account creation)   */
/*                  Add /COPY CGL135_113, CGL135_114                 */
/*       191263 - Add RCLRSC command to prevent GLC450 looping.      */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       110361  - Correct 090139.   OVRDBF to be SHARE(*NO)        */
/*       CMC001  - Management Accounts Enhancement for PCA:         */
/*                 Call MCC0310 to filter the Manual entries to     */
/*                 PF/MCMOVEPD.                                     */
/*       090139  - Add OVRDBF ACCNTX to override file ACCNT.        */
/*       S01408  - Addition of core hook GLC450MP1.                 */
/*       087618  - If Real Time Posting terminates because an a/c   */
/*                 is not open, send the user a message with the    */
/*                 a/c details to allow him to open the account.    */
/*               - Output correct DB Error details for an error in  */
/*                 GL0450 or GL0451.                                */
/*               - Add Global Monitor Message processing.           */
/*       047264  - OVRMSGF MIDAS TO APPROPRIATE LANGUAGE            */
/*       048237  -  Remove processing for MC module.                */
/*       S10736  -  Add processing for MC module.                   */
/*                                                                  */
/********************************************************************/
 
             PGM        PARM(&BNUM &WRKSTN)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL VAR(&BNUM)  TYPE(*CHAR) LEN(3)
             DCL VAR(&WRKSTN) TYPE(*CHAR) LEN(10)
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)               /*047264*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)                /*047264*/
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)                /*047264*/
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)                 /*047264*/
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)       /*047264*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*047264*/
             DCL        VAR(&MIDAS) TYPE(*CHAR) LEN(10)               /*047264*/
             DCL        VAR(&GLUSRMSG) TYPE(*CHAR) LEN(10)            /*087618*/
             DCL        VAR(&ACC) TYPE(*CHAR) LEN(18)                 /*087618*/
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(3)                  /*087618*/
             DCL        VAR(&BUSY)  TYPE(*CHAR) LEN(1)                /*CMC001*/
             DCL        VAR(&PRGC)  TYPE(*CHAR) LEN(2)                /*CMC001*/
             DCL        VAR(&CMC001) TYPE(*CHAR) LEN(1) VALUE('N')    /*CMC001*/
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN(7) VALUE(' ')     /*CMC001*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*CMC001*/
/*/COPY OFCPYSRCZ,CGL135_114                                         */ /*MD023889*/
/*/COPY WNCPYSRC,GLC450001                                           */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*087618*/
/*/COPY WNCPYSRC,GLC450005                                           */
 
/**********  STRCMTCTL  LCKLVL(*CHG)                                    CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
/************                                                /*S10736* *048237*/
/************DLTF GLPOSTL5X                                  /*S10736* *048237*/
/************MONMSG     MSGID(CPF2105)                       /*S10736* *048237*/
/************                                                /*S10736* *048237*/
 
/* Override MSGF/MIDAS to appropriate language */                     /*047264*/
                                                                      /*047264*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                              /*047264*/
             IF         COND(&MULT *EQ '  ') THEN(DO)                 /*047264*/
             CHGVAR     VAR(&MULT) VALUE('GB')                        /*047264*/
             ENDDO                                                    /*047264*/
                                                                      /*047264*/
             CHGVAR     VAR(&MIDAS) VALUE(&MULT *CAT 'MIDAS')         /*047264*/
             CHGVAR     VAR(&GLUSRMSG) VALUE(&MULT *CAT 'GLUSRMSG')   /*087618*/
             OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDAS)                    /*047264*/
             OVRMSGF    MSGF(GLUSRMSG) TOMSGF(&GLUSRMSG)              /*087618*/
                                                                      /*047264*/
/* Create LDA if it does not already exist */
 
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC450MP1                                           */
                                                                      /*S01408*/
                                                                      /*CMC001*/
/*  Check if Management Accounts Enhancement is installed.         */ /*CMC001*/
                                                                      /*CMC001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CMC001' +
                          &DSFDY)                                     /*CMC001*/
/* */                                                                 /*CMC001*/
/*  If Management Accounts Enhancement is installed, exclusively   */ /*CMC001*/
/*  allocate DTAARA/MC0220 to indicate that mgmt a/cs are in use   */ /*CMC001*/
/* */                                                                 /*CMC001*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*CMC001*/
                CHGVAR     VAR(&CMC001) VALUE('Y')                    /*CMC001*/
                ALCOBJ     OBJ((MC0220 *DTAARA *EXCLRD)) WAIT(0)      /*CMC001*/
                MONMSG     MSGID(CPF1002) EXEC(DO)                    /*CMC001*/
                SNDPGMMSG  MSG('Management accounts files cannot  +
                             be allocated at this time.') +
                             TOMSGQ(MRUNQ &WRKSTN)                    /*CMC001*/
                SNDPGMMSG  MSG('Transaction failed. Re-input +
                             necessary.') TOMSGQ(&WRKSTN MOPERQ)      /*CMC001*/
                ROLLBACK                                              /*CMC001*/
                CALL PGM(GL0451) PARM(&BNUM)                          /*CMC001*/
                GOTO       CMDLBL(ENDPGM)                             /*CMC001*/
                ENDDO                                                 /*CMC001*/
                DLYJOB     DLY(1)                                     /*CMC001*/
             ENDDO                                                    /*CMC001*/
                                                                      /*090139*/
/*/COPY OFCPYSRCZ,CGL135_113                                          */ /*MD023889*/
/************OVRDBF     FILE(ACCNTX) TOFILE(ACCNT)            *090139* *110361*/
             OVRDBF     FILE(ACCNTX) TOFILE(ACCNT) SHARE(*NO)         /*110361*/
 
/*/COPY WNCPYSRC,GLC450003                                           */
             CALL PGM(GL0450) PARM(&BNUM)
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                SNDPGMMSG  MSG('Transaction failed. Re-input +
                          necessary. Enter to continue.') +
                          TOMSGQ(&WRKSTN MOPERQ)
                ROLLBACK
                CALL PGM(GL0451) PARM(&BNUM)
             ENDDO
/*/COPY WNCPYSRC,GLC450004                                           */
             DLTOVR     FILE(ACCNTX)                                  /*090139*/
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               ROLLBACK
               RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                    /*087618*/
               CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))    /*087618*/
               CHGVAR     VAR(&ACC) VALUE(%SUBSTRING(&LDA 153 18))    /*087618*/
               CHGVAR     VAR(&ERR) VALUE(%SUBSTRING(&LDA 181 3))     /*087618*/
               IF         COND(&ERR *EQ '009') THEN(DO)               /*087618*/
                 SNDPGMMSG  MSGID(USR1001) MSGF(GLUSRMSG) MSGDTA(&ACC) +
                              TOPGMQ(*EXT) TOMSGQ(&WRKSTN MOPERQ)     /*087618*/
               ENDDO                                                  /*087618*/
               ELSE       CMD(DO)                                     /*087618*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(&WRKSTN MOPERQ)       /*087618*/
               ENDDO                                                  /*087618*/
                                                                      /*087618*/
               CALL PGM(GL0451) PARM(&BNUM)
               IF COND(%SWITCH(XXXXXX11)) THEN(DO)                    /*087618*/
               RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
               CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/****************CHGVAR     VAR(&MEM) VALUE('GLC450 - Job Termination, +
/****************           Database in Error')                       /*087618*/
/****************SNDPGMMSG  MSG(&MEM) TOMSGQ(&WRKSTN MOPERQ)          /*087618*/
               ENDDO                                                  /*087618*/
             GOTO       CMDLBL(ABNOR)                                 /*087618*/
             ENDDO
/* */                                                                 /*CMC001*/
/*  If Management Accounts Enhancement is installed, call MCC0310  */ /*CMC001*/
/*  to filter the Manual entries to MCMOVEPD.                      */ /*CMC001*/
/* */                                                                 /*CMC001*/
             IF         COND(&CMC001 *EQ 'Y') THEN(DO)                /*CMC001*/
/* */                                                                 /*CMC001*/
                CLRPFM     FILE(MCMOVEPD)                             /*CMC001*/
                CLRPFM     FILE(MCPST1PD)                             /*CMC001*/
                CALL       PGM(MCC0310) PARM('GERTPD')                /*CMC001*/
                IF COND(%SWITCH(XXXXXX11)) THEN(DO)                   /*CMC001*/
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                /*CMC001*/
                   CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))      /*CMC001*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)     /*CMC001*/
                   GOTO       CMDLBL(ABNOR)                           /*CMC001*/
                ENDDO                                                 /*CMC001*/
/* */                                                                 /*CMC001*/
                CPYF       FROMFILE(MCMOVEPD) TOFILE(MCPST1PD) +
                             MBROPT(*REPLACE)                         /*CMC001*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(MCPST1PD))              /*CMC001*/
/* */                                                                 /*CMC001*/
/*  Update the management accounts using the Real Time Posting     */ /*CMC001*/
/* */                                                                 /*CMC001*/
                CALL       PGM(MCC0350) PARM('1' 'MCC0350' +
                             X'00001F')                               /*CMC001*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           /*CMC001*/
                   CALL       PGM(CB0160) PARM('MCC0350' X'00001F' +
                                &BUSY)                                /*CMC001*/
/* */                                                                 /*CMC001*/
/*  If busy flag is 'Y', recover original version of Management    */ /*CMC001*/
/*  Accounts files GLHIBLPD and GLAVBLPD                           */ /*CMC001*/
/* */                                                                 /*CMC001*/
                   IF         COND(&BUSY *EQ 'Y') THEN(DO)            /*CMC001*/
                      CALL       PGM(AOPCACR0) PARM(&RTCD '*FIRST' +
                                   &DSFDY)                            /*CMC001*/
                      CHGVAR     VAR(&PRGC) VALUE(%SST(&DSFDY 15 2))  /*CMC001*/
                      CPYF       FROMFILE(XGLHIBLPD) TOFILE(GLHIBLPD) +
                                   FROMMBR(&PRGC) TOMBR(*FROMMBR) +
                                   MBROPT(*REPLACE)                   /*CMC001*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GLHIBLPD) +
                                   MBR(&PRGC))                        /*CMC001*/
                      CPYF       FROMFILE(XGLAVBLPD) TOFILE(GLAVBLPD) +
                                   FROMMBR(&PRGC) TOMBR(*FROMMBR) +
                                   MBROPT(*REPLACE)                   /*CMC001*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GLAVBLPD) +
                                   MBR(&PRGC))                        /*CMC001*/
                      CALL       PGM(CB0150) PARM('MCC0350' +
                                   X'00001F' 'N')                     /*CMC001*/
                      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)             /*CMC001*/
                      CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))   /*CMC001*/
                      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOPGMQ(*EXT) +
                                   TOMSGQ(MOPERQ MRUNQ)               /*CMC001*/
                   ENDDO                                              /*CMC001*/
                   GOTO       CMDLBL(ABNOR)                           /*CMC001*/
                ENDDO                                                 /*CMC001*/
/* */                                                                 /*CMC001*/
                DLCOBJ     OBJ((MC0220 *DTAARA *EXCLRD))              /*CMC001*/
             ENDDO                                                    /*CMC001*/
/*/COPY WNCPYSRC,GLC450002                                           */
 
             GOTO       CMDLBL(ENDPGM)                                /*087618*/
                                                                      /*087618*/
ABNOR:                                                                /*087618*/
             SNDPGMMSG  MSGID(USR1002) MSGF(GLUSRMSG) MSGDTA(&BNUM) +
                          TOPGMQ(*EXT) TOMSGQ(&WRKSTN MOPERQ MRUNQ)   /*087618*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*087618*/
             DMPCLPGM                                                 /*087618*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*087618*/
             DLTOVR     FILE(*ALL)                                    /*090139*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*090139*/
                                                                      /*087618*/
/*/COPY WNCPYSRC,GLC450006                                           */
/*ENDPGM:****ENDCMTCTL */                                             /*191263*/
 ENDPGM:                                                              /*191263*/
             RCLACTGRP  ACTGRP(*ELIGIBLE)                             /*191263*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*191263*/
             RCLRSC                                                   /*191263*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*191263*/
             ENDCMTCTL                                                /*191263*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*191263*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             DLTOVR     FILE(*ALL)                                    /*090139*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*090139*/
             ENDPGM
