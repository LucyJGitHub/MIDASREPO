/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE S352 Statements print')                      */
/*********************************************************************/
/*                                                                   */
/*        Midas - Retail Module                              */
/*                                                                   */
/*      REC2195 - S352 STATEMENTS PRINT                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 09May95              */
/*                      042015            DATE  08JUL92              */
/*                      S01383            DATE  27APR92              */
/*                                                                   */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                        */
/*       S01408 - Addition of core hook REC2195MPS                   */
/*       042015 - COMPONENT SEQUENCE NUMBER SHOULD NOT BE PASSED    */
/*                TO RE2195                                         */
/*                                                                  */
/*       S01383 - BASIC RATE TAX INCORPORATION                      */
/*                NEW PROGRAM                                       */
/*                                                                  */
/*                                                                  */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC)  LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SRTCD)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN)    TYPE(*CHAR) LEN(7) +
                        VALUE('*VERIFY')
             DCL        VAR(&SSARD)    TYPE(*CHAR) LEN(6) +
                        VALUE('S01383')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
/************CHGVAR*****&DPLIB**VALUE(%SUBSTRING(&SDSTAT 6 2)**'DPLIB') */ /*BG18886*/
             CHGVAR     &DPLIB  VALUE(%SUBSTRING(&SDSTAT 6 2) *CAT 'DPLIB')    /*BG18886*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC2195MPS                                          */
                                                                      /*S01408*/
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
                          Finastra International Limited')
/**/
/* Set-off Database Error Switches */
/**/
             CHGJOB     SWS(00000000)
 
/**/
/* DETERMINE IF BRT SAR INSTALLED */
/**/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
/**/
/* BRT SAR NOT INSTALLED */
/**/
             IF         COND(&SRTCD *NE '       ') THEN(DO)
                GOTO END
             ENDDO
 
/* CHECK FOR COMPONENT RESTART                                      */
 
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
/* IF RESTART, RESTORE SAVED FILES                                  */
 
             IF         COND(&BUSY = 'Y') THEN(DO)
 
             CPYF       FROMFILE(&DPLIB/XINTPSDD) TOFILE(INTPSDD) +
                          FROMMBR(INTPSDD) TOMBR(INTPSDD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(INTPSDD) MBR(INTPSDD))
 
/* CHANGE FLAG TO NOT BUSY              */
 
                CHGVAR     VAR(&BUSY) VALUE('N')
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
             ENDDO
 
/* SAVE FILES                                                       */
 
             DLTF       FILE(&DPLIB/XINTPSDD)
             MONMSG CPF0000
 
             CPYF       FROMFILE(INTPSDD) TOFILE(&DPLIB/XINTPSDD) +
                          CRTFILE(*YES)
 
/* CHANGE FLAG TO BUSY                  */
 
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
 
             CHGJOB     SWS(00000000)
/************CALL  PGM(RE2195) PARM(&CSEQ ' ') */                     /*042015*/
             CALL  PGM(RE2195) PARM(' ')                              /*042015*/
 
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
 
/*  SUCCESSFUL COMPLETION                                            */
 
/* CHANGE FLAG TO NOT BUSY              */
 
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
             CLRPFM     FILE(STMREQPD)
 
             DLTF       FILE(&DPLIB/XINTPSDD)
             MONMSG CPF0000
/**/
             GOTO       CMDLBL(END)
/**/
/* Database Error Messages will be sent by RCF */
/**/
 DBERR:      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
             MSGDTA(&MEM) TOMSGQ(MOPERQ) TOPGMQ(*EXT)
 
             GOTO       CMDLBL(END)
/**/
 ABNOR:      SNDPGMMSG  MSG('S352 Statements Print ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 END:        ENDPGM
