/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Exposure limits & mat. FX deals - extract')  */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Dealing Module                                 */
/*                                                                   */
/*       DLC0806A - EXPOSURE AGAINST LIMITS & MATURITY OF FX DEALS   */
/*                  - DATA EXTRACT                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CCB016  *CREATE    Date 28May08              */
/*      Midas Plus 1.4 Base -----------------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   CCB016 - CoB Performance Enhancements                           */
/*            Split DLC0806 into two components, DLC0806A for data   */
/*            extraction and DLC0806B for reporting.                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2008')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
 
/* Global monitor message                                                                         */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
             SNDMSG     MSG('EXPOSURE AGAINST ALL LIMITS DATA +
                          EXTRACT') TOMSGQ(MRUNQ)
 
             RMVM       FILE(EVLSC) MBR(EVLSC)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(EVLSR) MBR(EVLSR)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(EVLSX) MBR(EVLSX)
             MONMSG     MSGID(CPF0000)
 
             CLRPFM     FILE(EVLXCEC)
             CLRPFM     FILE(EVLXCEE)
             CLRPFM     FILE(EVLXCEG)
             CLRPFM     FILE(EVLXCED)
             CLRPFM     FILE(EVLXCBH)
             CLRPFM     FILE(EVLXCBE)
 
/* Set job switch U2 if Lending or S01360 are present                                             */
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF         COND(%SUBSTRING(&MMOD 4 1) = 'Y') +
                          THEN(CHGJOB SWS(X1XXXXXX))
             ELSE       CMD(DO)
                CHGVAR     VAR(&RTCD) VALUE('       ')
                CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'S01360')
                IF         COND(&RTCD *EQ '       ') THEN(CHGJOB +
                             SWS(X1XXXXXX))
             ENDDO
 
/* Block large files                                                                              */
 
             OVRDBF     FILE(EVLXCED) SEQONLY(*YES 100)
             OVRDBF     FILE(EVLXCEE) SEQONLY(*YES 100)
 
             CALL       PGM(DL0740)
             DLTOVR     FILE(EVLXCED)
             DLTOVR     FILE(EVLXCEE)
 
             ADDLFM     FILE(EVLSC) MBR(EVLSC) SHARE(*YES)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(EVLSR) MBR(EVLSR) SHARE(*YES)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(EVLSX) MBR(EVLSX) SHARE(*YES)
             MONMSG     MSGID(CPF0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(ENDPGM))
 
ABNOR:       IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDMSG     MSG('Job terminated - database in error') +
                             TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDMSG     MSG('File controls out of balance') +
                             TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             CHGJOB     SWS(XXXXXXX1)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM:      ENDPGM
