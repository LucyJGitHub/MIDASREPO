/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE ER Drop of Early Redemptions')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                       */
/*                                                                   */
/*       SEC6764 - SE Drop of Early Redemptions                      */
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
/*       Prev Amend No. S01408             Date 10May95              */
/*                      S01496             Date 07Oct94              */
/*                      S10978             DATE 19MAY93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hook SEC6764MPS                   *  S01189*/
/*       S01496 - Incorporation of JYSKE Enhancements (S10978)       */
/*       S10978 - JYSZRH: EARLY REDEMPTIONS                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
 
/* Retrieve Job attributes */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO)
 
/* Get system ID to build DLIB name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
/*********** CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DLIB')     */ /*S01496*/
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DPLIB')       /*S01496*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC6764MPS                                          */
                                                                      /*S01408*/
 
/* Send Information Program Message */
             SNDPGMMSG  MSG('SEC6764 - DROP OF EARLY REDEMPTIONS') +
                          TOMSGQ(MRUNQ)
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
/* Override to SEQONLY(*YES 100) */
             OVRDBF     FILE(SEERRFPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SEERDPPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SEERALPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSEERRFPD) SEQONLY(*YES 100)
             OVRDBF     FILE(XSEERDPPD) SEQONLY(*YES 100)
             OVRDBF     FILE(XSEERALPD) SEQONLY(*YES 100)
 
/* Retrieve the field indicating a Restart */
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
/* If it's a Restart, Restore Security Copies */
             IF         COND(&BUSY = 'Y') THEN(DO)
 
             CPYF       FROMFILE(&DLIB/XSEERRFPD) TOFILE(SEERRPFD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEERRFPD))
 
             CPYF       FROMFILE(&DLIB/XSEERDPPD) TOFILE(SEERDPPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEERDPPD))
 
             CPYF       FROMFILE(&DLIB/XSEERALPD) TOFILE(SEERALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEERALPD))
             ENDDO
 
             ELSE CMD(DO)
 
/* Delete Copy Files */
             DLTF       FILE(&DLIB/XSEERRFPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSEERDPPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSEERALPD)
             MONMSG MSGID(CPF0000)
 
             CPYF       FROMFILE(SEERRFPD) TOFILE(&DLIB/XSEERRFPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SEERDPPD) TOFILE(&DLIB/XSEERDPPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SEERALPD) TOFILE(&DLIB/XSEERALPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
             ENDDO
 
/* Delete overrides */
             DLTOVR     FILE(SEERRFPD SEERDPPD SEERALPD XSEERRFPD +
                          XSEERDPPD XSEERALPD)
 
/* Call RPG name */
             CALL       PGM(SE6764)
 
/* If error */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
               CHGJOB     SWS(XXXXXX11)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********   SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ) */ /*S01496*/
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*S01496*/
               SNDMSG     MSG('SE6764 ENDED ABNORMALLY FOR JOB ' *CAT +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********   SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ) */ /*S01496*/
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*S01496*/
               SNDMSG     MSG('SE6764 ENDED ABNORMALLY FOR JOB ' *CAT +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
/* If the job is completed normally */
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
/* Delete Security Copies */
             DLTF       FILE(&DLIB/XSEERRFPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSEERDPPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSEERALPD)
             MONMSG MSGID(CPF0000)
 
ENDCLPGM:    CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
