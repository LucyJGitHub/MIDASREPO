/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Loan Manager message transmission')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2017 - Lending PC Front-End Transmit Control Messages    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Last Amend No. 203561  *CREATE    Date 04Mar02              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       203561 - Loan Manager download does not take place if       */
/*                LEC2016 job is not running.                        */
/*                - New program LEC2017 added.                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&P#RTCD &P#MTYP &LMSERV &LMBRCH)
 
             DCL        VAR(&P#RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&P#MTYP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&P#QTYP) TYPE(*CHAR) LEN(4) VALUE('TRIC')
             DCL        VAR(&LMSERV) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LMBRCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Global Monitor Message:                                   */
/* If an unmonitored message occurs perform error processing */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
/* Determine MQ queue type from message type */
 
/* Bulk queue messages */
 
             IF         COND(&P#MTYP *EQ 'OPEN') THEN(CHGVAR +
                          VAR(&P#QTYP) VALUE('BULK'))
             IF         COND(&P#MTYP *EQ 'ROPN') THEN(CHGVAR +
                          VAR(&P#QTYP) VALUE('BULK'))
 
/* Drip feed queue messages */
 
             IF         COND(&P#MTYP *EQ 'REST') THEN(CHGVAR +
                          VAR(&P#QTYP) VALUE('TRIC'))
             IF         COND(&P#MTYP *EQ 'STRI') THEN(CHGVAR +
                          VAR(&P#QTYP) VALUE('TRIC'))
             IF         COND(&P#MTYP *EQ 'ENDI') THEN(CHGVAR +
                          VAR(&P#QTYP) VALUE('TRIC'))
             IF         COND(&P#MTYP *EQ 'STRD') THEN(CHGVAR +
                          VAR(&P#QTYP) VALUE('TRIC'))
             IF         COND(&P#MTYP *EQ 'ENDD') THEN(CHGVAR +
                          VAR(&P#QTYP) VALUE('TRIC'))
 
             CALL       PGM(LE2017) PARM(&P#RTCD &P#MTYP &P#QTYP +
                           &LMSERV &LMBRCH)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                           CMDLBL(ABNOR))
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Lending PC Front-End Control Message +
                          Transmission has ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/* Normal termination */
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd. 2002')
 
             ENDPGM
