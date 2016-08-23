/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Terminate market data feed')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas   - Standing Data Module                              */
/*                                                                   */
/*       SDC1470 - Terminate Market Data Feed                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CSD006  *CREATE    Date 13Jul00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD006 - Market Data Feeds                                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOBDSC) TYPE(*CHAR) LEN(32)
             DCL        VAR(&JOBNME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBUSR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Monitor for error messages not trapped in the rest of the program */
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Retrieve MDF batch monitor details                                */
 
             RTVDTAARA  DTAARA(SDMDFSTS (1  32)) RTNVAR(&JOBDSC)
 
/* Start commitment control */
 
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351)
 
/* Cancel the MDF batch monitor when job description not blank       */
 
             IF         COND(&JOBDSC *NE ' ') THEN(DO)
               CHGVAR     VAR(&JOBNME) VALUE(%SST(&JOBDSC 6 10))
               CHGVAR     VAR(&JOBUSR) VALUE(%SST(&JOBDSC 16 10))
               CHGVAR     VAR(&JOBNBR) VALUE(%SST(&JOBDSC 26 6))
               CHGDTAARA  DTAARA(SDMDFSTS (32 1)) VALUE('T')
               CHGDTAARA  DTAARA(SDMDFSTS (6 26)) VALUE(' ')
             ENDDO
 
/* Send message to the Market Watch application to stop the MDF to   */
/* the Midas system                                                  */
 
             CALL       PGM(SD1470)
 
/* Error on calling SD1470, send error message                       */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
               GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SDC1470 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
