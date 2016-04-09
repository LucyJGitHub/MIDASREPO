/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Reporting groups maintenance')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0140  -  REPORTING GROUPS MAINTENANCE                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 046075             DATE 20OCT92              */
/*       PREV AMEND NO. S01379             DATE 15SEP92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       046075 - DLTOVR missing which causes files created by       */
/*                HFC0142 to have incorrect member names             */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PONAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(30)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
STRPGM:
 
 
             CHGJOB     SWS(00000000)
 
/* */
/* Call maintenance program */
/* */
             CALL       PGM(HF0140) PARM(&PARM)
 
/* */
/*  Database error handling  */
/* */
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
 
                RTVDTAARA  DTAARA(QTEMP/LDA (134 44)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ENDPGM)
 
             ENDDO
 
/* */
/* Get the file name from the returned parameter                     */
/* */
             CHGVAR     VAR(&PONAM) VALUE(%SST(&PARM 11 10))
             IF         COND(&PONAM *EQ '         ') THEN(DO)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
 
/* */
/* Override the HFRGRPPD file with the file from LDA                 */
/* */
             OVRDBF     FILE(HFRGRPPD) TOFILE(&PONAM)
 
/* */
/* Call second maintenance program */
/* */
             CALL       PGM(HF0141) PARM(&PARM)
 
/* */                                                                /*046075*/
/* Delete override                                                */ /*046075*/
/* */                                                                /*046075*/
             DLTOVR     FILE(HFRGRPPD)                               /*046075*/
/* */
/*  Database error handling  */
/* */
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
 
                RTVDTAARA  DTAARA(QTEMP/LDA (134 44)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ENDPGM)
 
             ENDDO
 
/* */
/* Check returned values */
/* */
             CHGVAR     VAR(&PREV) VALUE(%SST(&PARM 26 1))
             CHGVAR     VAR(&DEL) VALUE(%SST(&PARM 27 1))
 
/* */
/* Delete requested */
/* */
             IF         COND(&DEL *EQ 'Y') THEN(DO)
             DLTOVR     FILE(*ALL)
             DLTF       FILE(&PONAM)
             ENDDO
 
/* */
/* Initial screen requested */
/* */
             IF         COND(&PREV *EQ '1') THEN(DO)
             GOTO       CMDLBL(STRPGM)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0140 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDPGM:     CHGJOB     SWS(00000000)
             DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
