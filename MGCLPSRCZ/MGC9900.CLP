/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MG Test Routing Information Test')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Generation Module                           */
/*                                                                   */
/*       MGC9900 - Routing Information Test                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CAAA02             Date 16Jul03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSW096             Date 05JUN96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CAAA02 - Remove use of INVITE keyword to enable WebFacing   */
/*                to process screens. Recompile only.                */
/*       CSW096 - SWIFT 96 Changes                                   */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement definition  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&P_IN) TYPE(*CHAR) LEN(256)
             DCL        VAR(&P_OUT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&P_ZZ) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
             DCL        VAR(&##TMEA) TYPE(*CHAR) LEN(6)
/* */
/* Declare Display file */
/* */
             DCLF       FILE(MGC9900DF)
/* */
/* Global Monitor Message */
/* */
/*           MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)        */
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* */
/* Set up screen variables */
/* */
             RTVJOBA    JOB(&##JOB) USER(&##USR)
             CHGVAR     VAR(&##PGM) VALUE('MGC9900')
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&##MRDT)
/* */
/* Get option name and function keys */
/* */
             RTVMSG     MSGID(MG99001) MSGF(MEMSG) MSG(&##ONAM)
             RTVMSG     MSGID(MG99002) MSGF(MEMSG) MSG(&##CMD2)
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MGC9900 - Routing Information Test') +
                          TOMSGQ(MRUNQ)
/* */
/* Present MGC9900DF to waiting for action */
/* */
 READSCRN:
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&##TMEA)
             CHGVAR     VAR(&##TME) VALUE(&##TMEA)
             SNDF       RCDFMT(#MSGCTL)
             SNDF       RCDFMT(#CMDTXT)
             SNDRCVF    RCDFMT(#RCDKEY) WAIT(*NO)
/* */
/* Read screen  */
/* */
             RCVF       RCDFMT(#RCDKEY)
/* */
/* If F3 then exit else loop and display screen again */
/* */
             IF         COND(&IN03 *EQ '1') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Remove messages from program queue */
/* */
             RMVMSG     CLEAR(*ALL)
/* */
/* Call MG9900 to obtain information */
/* */
             CHGVAR     VAR(&RTN_CDE) VALUE(' ')
             CHGVAR     VAR(&P_OUT) VALUE(' ')
             CHGVAR     VAR(&P_ZZ) VALUE(' ')
             CHGVAR     VAR(&P_IN) VALUE(&#1BRCA *CAT &#1DSCN *CAT +
                          &#1MTPY *CAT &#1SETT *CAT &#1CONC *CAT +
                          &#1FTCS *CAT &#1MMOD)
             CALL       PGM(MG9900) PARM(&RTN_CDE &P_IN &P_OUT &P_ZZ)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*SAME)
             CHGJOB     SWS(00000000)
             GOTO       CMDLBL(READSCRN)
             ENDDO
/* */
/* Obtain return parameters */
/* */
             CHGVAR     VAR(&#1BRCA) VALUE(%SST(&P_IN 1 3))
             CHGVAR     VAR(&#1DSCN) VALUE(%SST(&P_IN 4 6))
             CHGVAR     VAR(&#1CNSN) VALUE(%SST(&P_OUT 1 6))
             CHGVAR     VAR(&#1SWSN) VALUE(%SST(&P_OUT 7 12))
             CHGVAR     VAR(&#1NWSN) VALUE(%SST(&P_OUT 19 20))
             CHGVAR     VAR(&#1SWDS) VALUE(%SST(&P_OUT 39 12))
             CHGVAR     VAR(&#1NWDS) VALUE(%SST(&P_OUT 50 20))
             CHGVAR     VAR(&#1NWRK) VALUE(%SST(&P_OUT 70 6))
             CHGVAR     VAR(&#1MGSG) VALUE(%SST(&P_OUT 76 1))
             CHGVAR     VAR(&#1MGST) VALUE(%SST(&P_OUT 77 4))
             CHGVAR     VAR(&#1PAIN) VALUE(%SST(&P_OUT 81 1))
             CHGVAR     VAR(&#1PCNB) VALUE(%SST(&P_OUT 82 6))
             CHGVAR     VAR(&#1SPRS) VALUE(%SST(&P_OUT 88 3))
/* */
/* Read Screen */
/* */
             GOTO       CMDLBL(READSCRN)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MGC9900 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MGC9900 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
