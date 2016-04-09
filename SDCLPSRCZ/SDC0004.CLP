/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Initialisation program for CRE009')          */
/*********************************************************************/
/*                                                                   */
/*       Midas -                                                     */
/*                                                                   */
/*       SDC0004   - CRE009 Initialisation program                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CRE009  *Create    Date 03Sep02              */
/*       Prev Amend No. XXXXXX             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE009 - Projected Accounts Movements for Retail Accounts   */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&RTNCD &IMODE)
/**/
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&IMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(7) VALUE('CRE009')
             DCL        VAR(&DSDY) TYPE(*CHAR) LEN(200)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
/**/
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
/* CALL SD0004    TO INITIALISE NEW FIELD ON SYSTEM VALUE FILE     */
             CALL       PGM(SD0004)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNORMAL)
             ENDDO
 
/**/
/* CALL REC0940 TO BUILD PF/REPMFWPD    */
             CALL       PGM(REC0940)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNORMAL)
             ENDDO
 
/**/
 
                GOTO       CMDLBL(THEEND)
/**/
/**/
ABNORMAL:   DMPCLPGM
            MONMSG     MSGID(CPF0000 MCH0000)
            SNDMSG     MSG('PROGRAM TERMINATED ABNORMALLY.') +
                         TOMSGQ(MOPERQ MRUNQ)
            MONMSG     MSGID(CPF0000 MCH0000)
            CHGJOB     SWS(XXXXXX11)
            MONMSG     MSGID(CPF0000 MCH0000)
             CHGVAR     VAR(&RTNCD) VALUE(FAIL)
             MONMSG     MSGID(CPF0000)
 
THEEND:     CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                         Misys International Banking Systems Ltd.')
            ENDPGM
