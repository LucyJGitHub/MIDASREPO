/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Backup pager device creation parameters')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       SECONDARY - Secondary pager device creation parameters      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 098705             DATE 23JAN96              */
/*       PREV AMEND NO. S01491 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
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
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*  Create Secondary pager devices  Line        BUBEEPL            */ /*098705*/
/*                                  Controller  BUBEEPC            */ /*098705*/
/*                                  Device      BUBEEPD            */ /*098705*/
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
/************CRTLINSDLC LIND(BUBEEPL) RSRCNAME(LIN041) ONLINE(*YES) +  *098705*/
             CRTLINSDLC LIND(BUBEEPL) RSRCNAME(&LINE) ONLINE(*YES) +
                          ROLE(*PRI) INTERFACE(*RS232V24) +
                          CNN(*SWTPP) VRYWAIT(*NOWAIT) +
                          AUTOCALL(*NO) EXCHID(05600000) NRZI(*YES) +
                          MAXCTL(1) CLOCK(*MODEM) LINESPEED(2400) +
                          MODEM(*NORMAL) SWTCNN(*BOTH) +
                          AUTOANS(*YES) AUTODIAL(*YES) +
                          DIALCMD(*V25BIS) CALLNBR('<90399788212') +
                          CNNPOLLRTY(7) MAXFRAME(521) DUPLEX(*FULL) +
                          NPRDRCVTMR(320) IDLTMR(30) +
                          CNNPOLLTMR(300) POLLPAUSE(0) FRAMERTY(2) +
                          DSRDRPTMR(6) AUTOANSTYP(*DTR) +
                          RMTANSTMR(60) TEXT('Backup beeper line') +
                          MODEMRATE(*FULL) THRESHOLD(*OFF) +
                          MODULUS(8) MAXOUT(7) CTSTMR(25) +
                          LINKSPEED(9600) COSTCNN(128) +
                          COSTBYTE(128) SECURITY(*NONSECURE) +
                          PRPDLY(*TELEPHONE) USRDFN1(128) +
                          USRDFN2(128) USRDFN3(128) CMNRCYLMT(0 5)
/**/
             CRTCTLAPPC CTLD(BUBEEPC) LINKTYPE(*SDLC) ONLINE(*YES) +
                          SWITCHED(*YES) SHM(*NO) APPN(*NO) +
                          MAXFRAME(521) RMTNETID(*NONE) +
                          EXCHID(05600000) INLCNN(*DIAL) +
                          CNNNBR('<9<0399788212') ROLE(*SEC) +
                          STNADR(C5) TEXT('Backup beeper +
                          controller') CODE(*EBCDIC) PREDIALDLY(6) +
                          REDIALDLY(120) DIALRTY(2) SWTDSC(*YES) +
                          DSCTMR(30) POLLPTY(*YES) POLLLMT(0) +
                          OUTLMT(*POLLLMT) CNNPOLLRTY(2) +
                          NDMPOLLTMR(*CALC) CMNRCYLMT(0 5)
/**/
             CRTDEVAPPC DEVD(BUBEEPD) RMTLOCNAME(BUBEEP) +
                          ONLINE(*YES) LCLLOCNAME(*NETATR) +
                          RMTNETID(*NONE) CTL(BUBEEPC) MODE(BLANK) +
                          MSGQ(*LIBL/QSYSOPR) APPN(*NO) SNGSSN(*NO) +
                          SECURELOC(*NO) TEXT('Backup beeper +
                          device') LOCADR(00)
/**/
             CHGCTLAPPC CTLD(BUBEEPC) SWTLINLST(BUBEEPL)
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
/*  Error processing                                               */
/**/
 ABNOR:      SNDPGMMSG  MSG('Secondary pager device creation +
                          program ENDED ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&ERROR) VALUE('Y')                        /*098705*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
