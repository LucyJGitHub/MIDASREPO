/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Chqs Collection Waiting Complet'n')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                       */
/*                                                                   */
/*       FTC0185    Cheques for Collection Awaiting Completion       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMENDMENT NO. 061008             DATE  21SEP93         */
/*                                                                   */
/*********************************************************************/
/*  061008 - Missing functionality for FT Cheques processing         */
/*********************************************************************/
             PGM        PARM(&BRCH &BORO &PCMD)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&BRCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&BORO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             CHGJOB     SWS(XXXXXX00)
 
/*  Call program & monitor for errors                               */
 
             CALL       PGM(FT0185) PARM(&BRCH &BORO &PCMD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                          Press Enter to Continue.') TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
 
/*    Database error handling    */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/* CALL AOC8000 to release locks */
 
             CHGVAR     VAR(&MODULE) VALUE('FT')
             CHGVAR     VAR(&TRNREF) VALUE('               ')
             CHGVAR     VAR(&RINFOR) VALUE('    ')
             CHGVAR     VAR(&RTNCDE) VALUE('       ')
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)
 
            ENDPGM
 
