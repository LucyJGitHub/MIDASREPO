/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Primary pager device creation parameters')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       PRIMARY - Primary pager device creation parameters          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 098705             Date 23Jan96              */
/*                      S01491 *C *CREATE  Date 01Oct94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       098705 - Pass the Autocall line number as a parameter since */
/*                this will not always be LIN011.                    */
/*              - Pgm now called from ACC0009.                       */
/*       S01491 - Autocall.                                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/************PGM                                                   */ /*098705*/
             PGM        PARM(&LINE &ERROR)                            /*098705*/
/**/
             DCL        VAR(&LINE) TYPE(*CHAR) LEN(10)                /*098705*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)                /*098705*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
/*  Create Primary pager devices    Line        BEEPERL            */ /*098705*/
/*                                  Controller  BEEPERC            */ /*098705*/
/*                                  Device      BEEPERD            */ /*098705*/
/**/
/************CRTLINASC  LIND(BEEPERL) RSRCNAME(LIN011) ONLINE(*NO) +  /*098705*/
             CRTLINASC  LIND(BEEPERL) RSRCNAME(&LINE) ONLINE(*NO) +
                          INTERFACE(*RS232V24) CNN(*SWTPP) +
                          VRYWAIT(*NOWAIT) AUTOCALL(*NO) +
                          BITSCHAR(7) PARITY(*EVEN) STOPBITS(1) +
                          DUPLEX(*FULL) ECHO(*NONE) LINESPEED(2400) +
                          MODEM(*NORMAL) SWTCNN(*DIAL) +
                          AUTOANS(*YES) AUTODIAL(*YES) +
                          DIALCMD(*OTHER) CALLNBR(*NONE) +
                          INACTTMR(*NOMAX) MAXBUFFER(896) +
                          FLOWCNTL(*NO) DSRDRPTMR(6) +
                          AUTOANSTYP(*DTR) RMTANSTMR(60) +
                          TEXT('Primary beeper line') +
                          MODEMRATE(*FULL) THRESHOLD(*OFF) +
                          IDLTMR(1) CTSTMR(25) CMNRCYLMT(2 5)
/**/
             CRTCTLASC  CTLD(BEEPERC) LINKTYPE(*ASYNC) ONLINE(*NO) +
                          SWITCHED(*YES) INLCNN(*DIAL) +
                          CNNNBR('*NONE') TEXT('Primary beeper +
                          controller') PREDIALDLY(6) REDIALDLY(120) +
                          DIALRTY(2) SWTDSC(*NO) ACKTMR(16) +
                          RETRY(7) RMTVFY(*NO) CMNRCYLMT(2 5)
/**/
             CRTDEVASC  DEVD(BEEPERD) RMTLOCNAME(BEEPER) ONLINE(*NO) +
                          CTL(BEEPERC) TEXT('Primary beeper device')
/**/
             CHGCTLASC  CTLD(BEEPERC) SWTLINLST(BEEPERL)
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
/*  Error processing                                               */
/**/
 ABNOR:      SNDPGMMSG  MSG('Primary pager device creation program +
                          ENDED ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&ERROR) VALUE('Y')                        /*098705*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
