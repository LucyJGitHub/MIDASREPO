/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Rollover rate fixing advices control')       */
/*********************************************************************/
/*                                                                   */
/*       Midas    - Customer Lending Module                          */
/*                                                                   */
/*       LEC3165  - Rollover Rate Fixing Advices Control             */
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
/*                      193083             Date 11Jul01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CLE011  *CREATE    Date 07Nov00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       205448 - UDC module must be on for Correspondence Manager   */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*       193083 - Change ABNOR processing to stop loopingrocessing   */
/*       CLE011 - Rate Fixing Days for Lending Rollover Processing   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RPHASE &COMMIT)
 
             DCL        VAR(&RPHASE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COMMIT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SECLVL) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&TIMOUT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ERROR) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&LGUAGE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LERMSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDMMOD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CCG015*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('Lending Rollover Rate Fixing Advices') +
                          TOMSGQ(MRUNQ)
             CHGJOB     LOG(4) SWS(XXXXXX00)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&JLIB) VALUE(&PREFIX *CAT 'JLIB')
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')
             MONMSG     MSGID(CPF1023)
 
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
 
/* If during Input Cycle */
             IF         COND(&RPHASE = 'I') THEN(DO)
                CALL       PGM(SF0410) PARM(&GROUP &USER &SECLVL +
                          &TIMOUT &ERROR &LGUAGE)
                IF         COND(&ERROR = 1) THEN(DO)
                   SNDPGMMSG  MSG('User Defined Correspondence +
                          Extract Failure') TOMSGQ(MRUNQ MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
                IF         COND(&LGUAGE = '  ') THEN(DO)
                   CHGVAR     VAR(&LGUAGE) VALUE('GB')
                ENDDO
                CHGVAR     VAR(&LERMSGF) VALUE(&LGUAGE *CAT 'LERMSGF')
                OVRMSGF    MSGF(QUSERMSG) TOMSGF(&LERMSGF)
                ENDDO
 
/* If during COB */
             ELSE (DO)
                CHGVAR     VAR(&RTNCDE) VALUE('       ')
                CHGVAR     VAR(&OPTION) VALUE('*VERIFY')
                CHGVAR     VAR(&SARD) VALUE('CCB009')
                CHGVAR     VAR(&CCB009) VALUE('N')
                CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTION &SARD)
                IF         COND(&RTNCDE *EQ '       ') THEN(CHGVAR +
                          VAR(&CCB009) VALUE('Y'))
                ELSE (DO)
                   CRTJRNRCV  JRNRCV(&JLIB/JRLEC3165)
                   MONMSG     MSGID(CPF7010)
                   CRTJRN     JRN(&JLIB/JLEC3165) +
                                            JRNRCV(&JLIB/JRLEC3165)
                   MONMSG     MSGID(CPF7015)
                   STRJRNPF   FILE(CLOANCL) JRN(&JLIB/JLEC3165) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
                   MONMSG     MSGID(CPF7030)
                ENDDO
             ENDDO
 
             CHGVAR     VAR(&RTNCDE) VALUE('       ')
             CHGVAR     VAR(&OPTION) VALUE('*FIRST ')
             CALL       PGM(AOMMODR0) PARM(&RTNCDE &OPTION &SDMMOD)
/* If UDC is installed */
             IF         COND(%SST(&SDMMOD 101 1) *EQ 'Y') THEN(DO)
                                                                                          /*CCG015*/
/** Call Extract File Instance Management */                                              /*CCG015*/
                CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
                                                                                          /*CCG015*/
                OVRMSGF    MSGF(CGUSRMSG) TOMSGF(GBCGUSRMSG)
                OVRMSGF    MSGF(MIDAS) TOMSGF(GBMIDAS)
                CHGVAR     VAR(&RTNCDE) VALUE('       ')
                CALL       PGM(CG6070) PARM(&RTNCDE &COMMIT)
                IF         COND(&RTNCDE *NE '       ') THEN(DO)
                   ROLLBACK
                   SNDPGMMSG  MSG('User Defined Correspondence +
                          Extract Failure') TOMSGQ(MRUNQ MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
                                                                                          /*CCG015*/
/** Call Custom Defined Data Extract pgm */                                               /*CCG015*/
                CALL       PGM(CGC3604)                                                   /*CCG015*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                               /*CCG015*/
                   SNDPGMMSG  MSG('User Defined Correspondence +
                          Extract Failure') TOMSGQ(MRUNQ MOPERQ)                          /*CCG015*/
                   GOTO       CMDLBL(ABNOR)                                               /*CCG015*/
                ENDDO                                                                     /*CCG015*/
                                                                                          /*CCG015*/
             ENDDO
/* If UDC is NOT installed */
             ELSE       CMD(DO)
                CALL       PGM(LE3165) PARM('     ')
                IF         COND(*NOT %SWITCH(XXXXXX00) ) THEN(DO)
                   ROLLBACK
                   SNDPGMMSG  MSG('Rollover Rate Fix Advices print +
                          failure') TOMSGQ(MRUNQ MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* If UDC is installed */
             IF         COND(%SST(&SDMMOD 101 1) *EQ 'Y') THEN(DO)                        /*205448*/
/** Call Extract File Instance Management */                                              /*CCG015*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
                                                                                          /*CCG015*/
             ROLLBACK
             MONMSG     MSGID(CPF0000)                                                    /*193083*/
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)                                                    /*193083*/
             SNDPGMMSG  MSG('LEC3165 - Rollover Rate Fix Advices +
                          Print failed abnormally') TOMSGQ(MRUNQ +
                          MOPERQ)
             MONMSG     MSGID(CPF0000)                                                    /*193083*/
 
 END:
 
             IF         COND(&RPHASE *NE 'I') THEN(DO)
                IF         COND(&CCB009 *NE 'Y') THEN(DO)
                   ENDJRNPF   FILE(CLOANCL)
/************      MONMSG     MSGID(CPF7032)                                           */ /*193083*/
                   MONMSG     MSGID(CPF0000)                                              /*193083*/
                   DLTJRN     JRN(&JLIB/JLEC3165)
/************      MONMSG     MSGID(CPF2105)                                           */ /*193083*/
                   MONMSG     MSGID(CPF0000)                                              /*193083*/
                   DLTJRNRCV  JRNRCV(&JLIB/JRLEC3165) +
                            DLTOPT(*IGNINQMSG)
/************      MONMSG     MSGID(CPF2105)                                           */ /*193083*/
                   MONMSG     MSGID(CPF0000)                                              /*193083*/
                ENDDO
                ENDCMTCTL
/************   MONMSG     MSGID(CPF8355)                                              */ /*193083*/
                MONMSG     MSGID(CPF0000)                                                 /*193083*/
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
