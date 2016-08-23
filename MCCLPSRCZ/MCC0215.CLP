/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Management Accounts Report Ctl')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     GENERAL LEDGER MODULE                             */
/*                                                                   */
/*       MCC0215 - Management Accounts Report Control                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 057942             Date 15Jul94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       057942 - If the physical/logical file members for the       */
/*                control group do not exist, add them, else the     */
/*                default of MBR(*FIRST) will be used and the data   */
/*                for this member will be corrupted.                 */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&GPCD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BRCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CCY) TYPE(*CHAR) LEN(3)
/**********  DCL        VAR(&ACOD) TYPE(*CHAR) LEN(4)                */                   /*CGL029*/
             DCL        VAR(&ACOD) TYPE(*CHAR) LEN(10)                                    /*CGL029*/
             DCL        VAR(&ACSQ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRFC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BOKC) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TTYP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TSTP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACUS) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDYR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PDNO) TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* Create LDA if it does not already exist */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* Set-off Database Error Switches */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* Set up Parameters */
/**/
             CHGVAR     VAR(&GPCD) VALUE(%SST(&RPARM 1 2))
             CHGVAR     VAR(&BRCD) VALUE(%SST(&RPARM 4 3))
             CHGVAR     VAR(&CUST) VALUE(%SST(&RPARM 8 6))
             CHGVAR     VAR(&CCY) VALUE(%SST(&RPARM 15 3))
/**********  CHGVAR     VAR(&ACOD) VALUE(%SST(&RPARM 19 4))          */                   /*CGL029*/
             CHGVAR     VAR(&ACSQ) VALUE(%SST(&RPARM 24 2))
             CHGVAR     VAR(&PRFC) VALUE(%SST(&RPARM 27 4))
             CHGVAR     VAR(&BOKC) VALUE(%SST(&RPARM 32 2))
             CHGVAR     VAR(&TTYP) VALUE(%SST(&RPARM 35 10))
             CHGVAR     VAR(&TSTP) VALUE(%SST(&RPARM 46 10))
             CHGVAR     VAR(&ACUS) VALUE(%SST(&RPARM 57 6))
             CHGVAR     VAR(&PDYR) VALUE(%SST(&RPARM 64 4))
             CHGVAR     VAR(&PDNO) VALUE(%SST(&RPARM 69 2))
             CHGVAR     VAR(&USER) VALUE(%SST(&RPARM 72 10))
             CHGVAR     VAR(&ACOD) VALUE(%SST(&RPARM 83 10))                              /*CGL029*/
/* */                                                                /*057942*/
/** If the required members do not exist, create them.            */ /*057942*/
/** This will be required where a database is restored containing */ /*057942*/
/** control groups for which the pf/lf members do not exist.      */ /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLHIBLPD) OBJTYPE(*FILE) MBR(&GPCD)      /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(GLHIBLPD) +
                        MBR(&GPCD))                                  /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLHIBLL3) OBJTYPE(*FILE) MBR(&GPCD)      /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLHIBLL3) +
                        MBR(&GPCD) DTAMBRS((GLHIBLPD (&GPCD))))      /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLAVBLPD) OBJTYPE(*FILE) MBR(&GPCD)      /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(GLAVBLPD) +
                        MBR(&GPCD))                                  /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLAVBLL1) OBJTYPE(*FILE) MBR(&GPCD)      /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLAVBLL1) +
                        MBR(&GPCD) DTAMBRS((GLAVBLPD (&GPCD))))      /*057942*/
/* */                                                                /*057942*/
/* Override files to required member */
/**/
             OVRDBF     GLHIBLL3 MBR(&GPCD)
             OVRDBF     GLAVBLL1 MBR(&GPCD)
/**/
/* Call Report Program */
/**/
             CALL       PGM(MC0215) PARM(&GPCD &BRCD &CUST &CCY &ACOD +
                                        &ACSQ &PRFC &BOKC &TTYP &TSTP +
                                        &ACUS &PDYR &PDNO &RSEQ &USER)
/**/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
             GOTO       CMDLBL(END)
/**/
/* Database Error Messages will be sent by RCF */
/**/
 DBERR:      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
             MSGDTA(&MEM) TOMSGQ(MOPERQ) TOPGMQ(*EXT)
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:      SNDPGMMSG  MSG('Management Accounts Report Request ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 END:        ENDPGM
