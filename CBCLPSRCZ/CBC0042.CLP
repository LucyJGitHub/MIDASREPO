/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Sundry Postings - CoB Init Routine')         */
/*********************************************************************/
/*                                                                   */
/*      Midas     - General Ledger Module                            */
/*                                                                   */
/*      CBC0042 - COB Initialization Routine                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CGL030 *CREATE     Date 18Dec09              */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGL030 - Sundry Postings                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&ACCR) TYPE(*DEC) LEN(1 0)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* SET UP GLOBAL VALUES */
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CGL030' +
                          &AOFMT)
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(END))
             CALL       PGM(EODCHK) PARM(&ACCR)
 
/* CALL FILE INIT ROUTINE */
             CALL CB0042 (&ACCR)
             GOTO       CMDLBL(END)
 
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            CBC0042 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
 
             ENDPGM
