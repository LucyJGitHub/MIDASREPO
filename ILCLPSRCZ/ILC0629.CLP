/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Accounting merge')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0629  - IBLC 2002 - Create EODPOPD records               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX043             Date 29Sep01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/***  Declare variables.  ***/
 
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8) VALUE('00000000')
 
/***         Offsets for file indicators in the GLSTAT data area      ***/
             DCL        VAR(&ACPO1) TYPE(*DEC) LEN(3 0) VALUE(049)
             DCL        VAR(&ACPO2) TYPE(*DEC) LEN(3 0) VALUE(050)
             DCL        VAR(&ACPO3) TYPE(*DEC) LEN(3 0) VALUE(051)
             DCL        VAR(&ACPO4) TYPE(*DEC) LEN(3 0) VALUE(052)
             DCL        VAR(&ACPO5) TYPE(*DEC) LEN(3 0) VALUE(053)
             DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
 
/***  Retrieve ILSTAT data area to check if module is selected.  ***/
/***  Pos 1  : IBLC COB Componenet must run.  ***/
 
             RTVDTAARA  DTAARA(ILSTAT) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/***  Send message to program message queue.  ***/
 
             SNDPGMMSG  MSG('ILC0629 - IBLC 2002 - EODPOPD +
                          Generation.') TOMSGQ(MRUNQ MOPERQ)
 
/***  Format 'TO Library name' For Backup Copies.  ***/
 
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)
             IF         COND(%SUBSTRING(&GLSTAT &ACPO2 1) = 'Y') +
                        THEN(CHGVAR VAR(%SUBSTRING(&SWS 2 1)) VALUE('1'))
             IF         COND(%SUBSTRING(&GLSTAT &ACPO3 1) = 'Y') +
                        THEN(CHGVAR VAR(%SUBSTRING(&SWS 3 1)) VALUE('1'))
             IF         COND(%SUBSTRING(&GLSTAT &ACPO4 1) = 'Y') +
                        THEN(CHGVAR VAR(%SUBSTRING(&SWS 4 1)) VALUE('1'))
             IF         COND(%SUBSTRING(&GLSTAT &ACPO5 1) = 'Y') +
                        THEN(CHGVAR VAR(%SUBSTRING(&SWS 5 1)) VALUE('1'))
 
/***  Set job switches.  ***/
 
             CHGJOB     SWS(&SWS)
 
/***  Clear EODPOxx files. ***/
 
             CLRPFM     FILE(EODPOHH)
             CLRPFM     FILE(EODPOPD)
             CLRPFM     FILE(EODPORA)
             CLRPFM     FILE(EODPOZZ)
 
/***  Setup Switch 6 depending on condition below.  ***/
 
             IF         COND((%SST(&GLSTAT &ACPO1 1) = 'Y') *OR +
                          (%SST(&GLSTAT &ACPO5 1) = 'Y')) +
                          THEN(CHGJOB SWS(XXXXX1XX))
             ELSE       CMD(CHGJOB SWS(XXXXX0XX))
 
/***  Block Large Files.   ***/
 
             OVRDBF     FILE(EODPOPD) SEQONLY(*YES 100)
             OVRDBF     FILE(EODPORA) SEQONLY(*YES 100)
 
/***  Call MERGE Program.   ***/
 
             CALL       PGM(GL0400)
 
             DLTOVR     FILE(EODPOPD)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(EODPORA)
             MONMSG     MSGID(CPF0000)
 
/***  Out balance message.  ***/
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('ILC0629 - FILE OUT OF BALANCE - ACPO') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Send Message to user alerting failure.  ***/
 
 ABNORMAL:   SNDPGMMSG  MSG('ILC0629 - IBLC Accounting merge ended +
                          abnormally.') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
/***  End Program.  ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
