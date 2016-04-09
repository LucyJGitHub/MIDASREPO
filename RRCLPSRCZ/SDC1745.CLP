/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Reset FF Mkt Data Areas-Cancel Holds')          */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Restart Recovery Module                   */
/*                                                                   */
/*     SDC1745 - RESET MARKET DATA AREAS TO CANCEL REQUESTED HOLDS   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. 00                 DATE 00/00/00               */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCLF       FILE(MKCTL)
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
/* PROCESS EVERY MARKET                                              */
/**/
 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
/**/
/*                                                                   */
/* PROCESS ALL FILES IF MARKET CENTRE MEMBERS HAVE BEEN SET UP       */
/*                                                                   */
                IF         COND(&MKCI *EQ 'S') THEN(GOTO READ)
/* CHANGE MARKET DATA AREA TO CANCEL ANY REQUESTED HOLDS             */
/**/
             CHGDTAARA  DTAARA(&MRKT (1 1)) VALUE(' ')
/**/
             GOTO       CMDLBL(READ)
/**/
/* ABNORMAL TERMINATION PROCESSING */
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1745 - Reset market data +
                          areas clearing requested holds - ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
