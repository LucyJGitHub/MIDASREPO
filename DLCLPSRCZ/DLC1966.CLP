/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL IR IRS Discount Factors Rebuild - COB')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - FRA/IRS Module                                      */
/*                                                                   */
/*       DLC1966 - IRS DISCOUNT FACTORS REBUILD - COB                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*    LAST AMEND NO. CIR001             DATE 13JUN95                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*    CIR001 - Interest Rate Calendars                               */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&TERM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)
/*/COPY WNCPYSRC,DLC1966001                                          */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/*/COPY WNCPYSRC,DLC1966002                                          */
              SNDMSG     MSG('DL1966 - IRS Discount Factors Rebuild') +
                         TOMSGQ(MRUNQ)
 
              CLRPFM     FILE(DLIRDFPD)
 
              CALL       PGM(DL1965)
 
/* Monitor for database error and send appropriate message to MOPERQ */
              IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                         CMDLBL(ERROR))
 
             GOTO       CMDLBL(END)
ERROR:       CHGVAR     VAR(&TERM) VALUE('E')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
