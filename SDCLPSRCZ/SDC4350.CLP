/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD PM Power of Attorney List')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC4350 - SD Power of Attorney List                         */
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
/*       Prev Amend No. CPM005             Date 22Jul96              */
/*                      S01124             Date 17May94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*       S01124 - PBFG/6 - Additional Customer Details               */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*CPM005*/
             PGM        PARM(&TYPE &RSEQ &RLEV &RENT)                 /*CPM005*/
/**/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)              */ /*CPM005*/
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*CPM005*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(3)                 /*CPM005*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(1)                 /*CPM005*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CPM005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*********** RTVJOBA    TYPE(&TYPE)                                */ /*CPM005*/
/**/
/* GLOBAL MONITOR MESSAGE                                                     */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
/**/
/*  SET OFF SWITCHES:                                                         */
             CHGJOB     SWS(00000000)
/**/
/*  CASE OF EOD -> TYPE IS BATCH                                              */
/*  OPEN QUERY FILE TO SELECT RECORD CHANGED TODAY                            */
             IF         COND((&TYPE *EQ '0')) THEN(DO)
             OVRDBF     FILE(SDPATTL1) SHARE(*YES)
/*********** OPNQRYF    FILE((*LIBL/SDPATTL1) (SDBANKPD)) +          * *CPM005*/
/***********              FORMAT(*LIBL/SDPATTL1) QRYSLT('FBLCD *EQ + * *CPM005*/
/***********              BJRDNB') KEYFLD((FBCUST *ASCEND) (FBUSID + * *CPM005*/
/***********              *ASCEND))                                  * *CPM005*/
             OPNQRYF    FILE((*LIBL/SDPATTL1) (SDBANKPD)) +
                          FORMAT(*LIBL/SDPATTL1) QRYSLT('F2LCD *EQ +
                          BJRDNB') KEYFLD((F2CUST *ASCEND) (F2URID +
                          *ASCEND))                                   /*CPM005*/
/*********** CALL       PGM(SD3160) PARM(' ')                      */ /*CPM005*/
             CALL       PGM(SD4350P) PARM(&RSEQ ' ')                  /*CPM005*/
             DLTOVR     FILE(SDPATTL1)
             CLOF       OPNID(SDPATTL1)
/**/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)      */ /*CPM005*/
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +        */ /*CPM005*/
/***********              MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)        */ /*CPM005*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CPM005*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                          MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)           /*CPM005*/
             ENDDO
             ENDDO
/**/
             ELSE (DO)
/*  CASE OF ON REQUEST REPORTING -> TYPE IS INTERACTIF                        */
             IF         COND((&TYPE *EQ '1')) THEN(DO)
/*********** CALL       PGM(SD3160) PARM('F')                      */ /*CPM005*/
             CALL       PGM(SD4350P) PARM(&RSEQ 'F')                  /*CPM005*/
             ENDDO
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)      */ /*CPM005*/
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +        */ /*CPM005*/
/***********              MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)        */ /*CPM005*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CPM005*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                          MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)           /*CPM005*/
/**/
             ENDDO
             ENDDO
             GOTO       CMDLBL(ENDPGM)
/**/
ENDTAG:      DMPCLPGM
/***ENDPGM:* ENDPGM                                                */ /*CPM005*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*CPM005*/
