/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Consolidated confirmations print')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC1180 - Consolidated Confirmation Print                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*                      205448             Date 02May02              */
/*                      CCG015             Date 09Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CLE004 *Create     Date 02Dec96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       205448 - UDC module must be on for Correspondence Manager   */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CLE004 - Customer Lending Enhancements - Syndications       */
/*                                                                   */
/*********************************************************************/
             PGM      PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ACTION)     TYPE(*CHAR) LEN(8)                               /*CCG015*/
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             SNDPGMMSG  MSG('Input Cycle Confirmations Reprint') +
                        TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(XXXXXX00)
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
/**/
/*  User Defined Correspondence processing. */
/**/
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')
/**/
/*  Access PF/SDMMODPD to determine whether UDC module is on.   */
/**/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)
/**/
/*  Database error handling.                                    */
/**/
             IF         COND(&RTCD *NE '       ') THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Error on access to ICD  +
                             file SDMMODPD')
                GOTO       CMDLBL(ABNOR)
             ENDDO
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                                                                                          /*CCG015*/
/** Run Extract File Instance Management */                                               /*CCG015*/
                CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
/**/
/************IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                OVRDBF     FILE(CLOAN) SHARE(*NO)
                OVRDBF     FILE(LELOANL4) SHARE(*NO)
                OVRDBF     FILE(LOAMS) SHARE(*NO)
                CALL       PGM(CG6061) PARM(&W0RTN &W0CMT &RENT &RPARM)
                DLTOVR     FILE(CLOAN LELOANL4 LOAMS)
                RCLRSC
                IF         COND(&W0RTN *NE '       ') THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('User Defined +
                                Correspondence Extract failure')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
/************ENDDO                                                                        /*205448*/
                                                                                          /*CCG015*/
/** Run Custom Define Data Extract */                                                     /*CCG015*/
                CALL CGC3604                                                              /*CCG015*/
                                                                                          /*CCG015*/
/** Check for Database errors trapped by program */                                       /*CCG015*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                               /*CCG015*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                              /*CCG015*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                  /*CCG015*/
                GOTO       CMDLBL(ABNOR)                                                  /*CCG015*/
                ENDDO                                                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
 
/**/
/* Process Consolidated Confirmation */
/**/
             CALL       PGM(LE1180) PARM(&RSEQ &RENT &RPARM)
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                COMMIT
                GOTO       CMDLBL(END)
             ENDDO
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             ENDDO
/**/
/* Abnormal or database error processing */
/**/
 ABNOR:                                                                                   /*CCG015*/
/***ABNOR:*     ROLLBACK */                                                               /*CCG015*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
             ROLLBACK                                                                     /*CCG015*/
             IF         COND(&MSG = ' ') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Consolidated Confirmations +
                          print failure')
             ENDDO
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/**/
 END:        ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
