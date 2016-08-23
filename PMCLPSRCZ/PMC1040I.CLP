/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Maintain PMSTAT (COB)')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC1040I - MAINTAIN DATA AREA PMSTAT                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CPK009             DATE 16AUG99              */
/*       PREV AMEND NO. S01408             DATE 05MAY95              */
/*                      S01486             DATE 28SEP94              */
/*                      049421     BZ      DATE 18JAN93              */
/*                      048601     BZ      DATE 28DEC92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK009 - Recompile prblems found in DBA R3.00 packaging.    */
/*       S01408 - Addition of core hook PMC1040IMS                   */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       048601 - WRITTEN FOR R3 COB                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/* DECLARE VARIABLES */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)                 *S01486*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                /*S01486*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
 
 
/************CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)         *S01486*/
/************MONMSG     MSGID(CPF1023)                                 *S01486*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
/************CHGVAR     VAR(&DLIB) VALUE(&SYSID *TCAT 'DLIB')          *S01486*/
             CHGVAR     VAR(&DLIB) VALUE(&SYSID *TCAT 'DPLIB')        /*S01486*/
             CHGVAR     VAR(&DMLIB) VALUE(&SYSID *TCAT 'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1040IMS                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL CB0160 (&CNAM &CSEQ &BUSY)
             IF         COND(&BUSY *NE 'Y') THEN(DO)
             DLTDTAARA  DTAARA(&DLIB/XPMSTAT)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(PMSTAT) FROMLIB(&DMLIB) OBJTYPE(*DTAARA) +
                          TOLIB(&DLIB) NEWOBJ(XPMSTAT)
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL CB0150 PARM(&CNAM &CSEQ &BUSY)
             ENDDO
             ELSE DO
/************CPYDTAARA  DTAARA1(&DLIB/XPMSTAT) DTAARA2(&DMLIB/PMSTAT)    *CPK009*/
             CPYDTAARA  FMDTAARA(&DLIB/XPMSTAT) +
                          TODTAARA(&DMLIB/PMSTAT)                       /*CPK009*/
             ENDDO
 
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* CALL RPG PROGRAM */
             CALL       PGM(PM1040) PARM('N')
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************   RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/************   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(END)
             ENDDO
             DLTDTAARA  DTAARA(&DLIB/XPMSTAT)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(PMSTAT (20 1)) VALUE('N')
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL CB0150 (&CNAM &CSEQ &BUSY)
END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
