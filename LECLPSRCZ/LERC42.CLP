/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Prof Format File Audit List')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC42  - Profitability format file audit list              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 000005             DATE 15APR92              */
/*       PREV AMEND NO.                    DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       000005 - Commercial Banking System Test                     */
/*                                                                   */
/*********************************************************************/
/***PGM******&MODE                                           000005*/
             PGM                                           /*000005*/
/************DCL        &MODE *CHAR 1                        000005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/**If*mode*=*'A'*(Update)*Take*Security*copy*of*Profitabilty*000005*/
/* Take Security copy of Profitabilty          */          /*000005*/
/* Format Control File & Cross-Reference File  */
 
/****IF*********COND(&MODE = 'A') THEN(DO)                   000005*/
 
        CPYF    FROMFILE(PEFMTC) TOFILE(XPFMTC) MBROPT(*REPLACE)
        MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XPFMTC))
        CPYF    FROMFILE(PEXREF) TOFILE(XPXREF) MBROPT(*REPLACE)
        MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XPXREF))
 
/****ENDDO                                                   000005*/
 
/********CALL       LER420 &MODE                             000005*/
         CALL       PGM(LER420)
 
         IF COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('Job terminated - database in error. +
                          Contact Systems Operator.') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             CHGJOB SWS(00000000)
 
/**************IF         COND(&MODE = 'A') THEN(DO)        000005*/
             CPYF FROMFILE(XPFMTC) TOFILE(PEFMTC) MBROPT(*REPLACE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                      FILE(PEFMTC))
             CPYF FROMFILE(XPXREF) TOFILE(PEXREF) MBROPT(*REPLACE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                      FILE(PEXREF))
/**************ENDDO                                        000005*/
 
         ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
         ENDPGM
