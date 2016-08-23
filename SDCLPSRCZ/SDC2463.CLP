/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas BRT Control Data Maintenance')                  */
/********************************************************************/
/*                                                                  */
/*    Midas Standing Data Module                            */
/*                                                                  */
/*     SDC2463 - BRT DATA CONTROL MAINTENANCE                       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO.  S01383           DATE 27APR92                */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*    S01383  -  BASIC RATE TAX INCORPORATION                       */
/*               NEW PROGRAM                                        */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL       VAR(&LDA)   TYPE(*CHAR)  LEN(256)
/**/
             CHGJOB SWS(00000000)
/**/
             CALL       PGM(SD2463)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
                ENDDO
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                      */
/**/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:      ENDPGM
