/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Citydealer LE Cashflow Extract Control')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0006 - Citydealer LE Cashflow Extract Control.           */
/*                                                                   */
/*       Function: This program will be called during Close of       */
/*                 Business processing.  It may only run after       */
/*                 GLC0802A has completed.  The file PF/DLCDNCPD     */
/*                 will be cleared and will call PGM/DL0006.         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CCM002 *CREATE     DATE 04SEP95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCM002 - Midas/Citydealer Interface (Phases V and VI)       */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*    Global monitor message                                         */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             SNDPGMMSG  MSG('DLC0006 - Citydealer Customer Lending +
                          Cashflow Extract') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
/*    Clear database file PF/DLCDNCPD                                */
/**/
             CLRPFM     FILE(DLCDNCPD)
/**/
/*    Call LE Cashflow Extract program.                              */
/**/
             CALL       PGM(DL0006)
/**/
/*    Database error processing                                      */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/*   Abnormal termination - batch job                                */
/**/
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Citydealer LE Cashflow Extract +
                          ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
