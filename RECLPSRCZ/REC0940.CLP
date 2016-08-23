/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CRE009 Projected Movm End Date Set up')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - RETAIL MODULE                                       */
/*                                                                   */
/*       REC0940 -                                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CRE009  *CREATE    Date 23Aug02              */
/*       Prev Amend No.                    Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE009 - Projected Accounts Movements for Retail Accounts   */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
/**/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(7) VALUE('CRE009')
             DCL        VAR(&DSDY) TYPE(*CHAR) LEN(200)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
/**/
/* RETRIEVE SYSTEM ID */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DPLIB) VALUE(&PRE *TCAT 'DPLIB')
 
/**/
/* GLOBAL MONITOR MESSAGE */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
             SNDPGMMSG  MSG('REC0940 - CRE009') TOMSGQ(MRUNQ)
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
 
             CHGJOB     SWS(XXXXXX00)
 
/**/
/* CHECK IF CRE009 IS ON */
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSDY)
             IF         COND(&RTCD *NE '       ') +
                           THEN(GOTO CMDLBL(THEEND))
/**/
/* CLEAR PF/REPMFWPD */
             CLRPFM     FILE(REPMFWPD)
             MONMSG     MSGID(CPF0000)
 
/**/
/* CREATE DTAARA REPMED */
             CHKOBJ     OBJ(&DPLIB/REPMED) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
                CRTDTAARA  DTAARA(&DPLIB/REPMED) TYPE(*CHAR) LEN(5)
             ENDDO
 
/**/
/* CALL RE0940 TO BUILD PF/REPMFWPD */
             CALL       PGM(RE0940)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNORMAL)
             ENDDO
 
                GOTO       CMDLBL(THEEND)
/**/
ABNORMAL:   DMPCLPGM
            MONMSG     MSGID(CPF0000 MCH0000)
            SNDMSG     MSG('PROGRAM TERMINATED ABNORMALLY.') +
                         TOMSGQ(MOPERQ MRUNQ)
            MONMSG     MSGID(CPF0000 MCH0000)
            CHGJOB     SWS(XXXXXX11)
            MONMSG     MSGID(CPF0000 MCH0000)
 
THEEND:     CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                         Misys International Banking Systems Ltd.')
            ENDPGM
