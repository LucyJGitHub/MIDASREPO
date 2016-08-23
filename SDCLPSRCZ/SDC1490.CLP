/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Market data feed batch monitor')             */
/*********************************************************************/
/*                                                                   */
/*       Midas   - Standing Data Module                              */
/*                                                                   */
/*       SDC1490 - Market Data Feed batch monitor                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CSD006  *CREATE    Date 30Nov00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD006 - Market Data Feeds                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTNCD &MSGDT)
 
             DCL        VAR(&JOBNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNU) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DLYTM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MDFSTA) TYPE(*CHAR) LEN(32)
             DCL        VAR(&MSGDT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Monitor for error messages not trapped in the rest of the program */
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
/* Create LDA                                                        */
             CALL       PGM(ZACCRTLDA) PARM(&RETURNCODE)
             IF         COND(&RETURNCODE *NE ' ') THEN(DO)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGDTAARA  DTAARA(LDA) VALUE(*BLANK)
             CHGJOB     SWS(XXXXXX00)
 
/* Start commitment control                                          */
 
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351)
 
/* Allocate initialisation data area SDC1490                         */
 
             ALCOBJ     OBJ((SDC1490 *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(MSG))
 
/* Retrieve velues from data area */
 
             RTVJOBA    JOB(&JOBNM) USER(&USRNM) NBR(&JOBNU)
             RTVDTAARA  DTAARA(SDMDFSTS  (1 32)) RTNVAR(&MDFSTA)
             CHGVAR     VAR(&DLYTM) VALUE(%SST(&MDFSTA 1 5))
 
/* Update data area */
 
             CHGVAR     VAR(%SST(&MDFSTA 6 10)) VALUE(&JOBNM)
             CHGVAR     VAR(%SST(&MDFSTA 16 10)) VALUE(&USRNM)
             CHGVAR     VAR(%SST(&MDFSTA 26 6)) VALUE(&JOBNU)
             CHGVAR     VAR(%SST(&MDFSTA 32 1)) VALUE(&JOBSTS)
             CHGDTAARA  DTAARA(SDMDFSTS) VALUE(&MDFSTA)
 
/* Infinite loop */
 
 FOREVER:
             CALL       PGM(SD1490) PARM(&RTNCD &MSGDT)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             IF         COND(&RTNCD *NE ' ') THEN(DO)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             DLYJOB     DLY(&DLYTM)
 
/* Check for termination instruction */
 
             RTVDTAARA  DTAARA(SDMDFSTS (32 1)) RTNVAR(&JOBSTS)
 
             IF         COND(&JOBSTS *EQ 'T') THEN(DO)
               CHGDTAARA  DTAARA(SDMDFSTS (32 1)) VALUE(' ')
               GOTO       CMDLBL(ENDPGM)
             ENDDO
 
             GOTO       CMDLBL(FOREVER)
 
/* At this stage the process has run normally */
 
             GOTO       CMDLBL(ENDPGM)
 
 MSG:
             CHGVAR     VAR(&RTNCD) VALUE('SCM0181')
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
             DMPCLPGM
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SDC1490 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             DLCOBJ     OBJ((SDC1490 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDPGM
