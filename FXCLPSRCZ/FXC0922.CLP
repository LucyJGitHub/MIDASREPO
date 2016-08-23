/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FX Confirmed nets deals details report')        */
/*********************************************************************/
/*                                                                   */
/*      Midas - (DL FX) Module                                       */
/*                                                                   */
/*      FXC0922 - Confirmed Net Deals Report                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*      Last Amend No. CPK009                Date 09Aug99            */
/*      Prev Amend No. CDL002  *CREATE       DATE 03MAR97            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*      CDL002 - FX Netting                                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SEQ &LVL &ETTY &PRAM)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ETTY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRAM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**********  STRCMTCTL  LCKLVL(*CHG)                                    CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
 
             CHGJOB     SWS(XXXXXX00)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
             OVRDBF     FILE(SDBRCHL1) SHARE(*NO)                     /*090740*/
 
             CALL       PGM(FX0922) PARM(&SEQ &LVL &ETTY &PRAM)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                  CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(THEEND))
 
 ABNOR:      SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FXC0922 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(THEEND))
 
THEEND:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
