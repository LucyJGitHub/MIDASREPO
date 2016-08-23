/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TM Control Take On Main Menu')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     Treasury Management Module                    */
/*                                                                   */
/*       TMC0100 - Controlling program to takeon trades and update   */
/*                 TM enquiry files.                                 */
/*                                                                   */
/*       Function:  Controls the menu which gives the options        */
/*                  to takeon FX, MM and AB deals and update the TM  */
/*                  maintenance enquiry files.                       */
/*                  This program is based on FD0710.                 */
/*                                                                   */
/*       Called by: None (run after setup of TM files by SCBEGIN and */
/*                  before Next Day Setup)                           */
/*                                                                   */
/*       Calls:     SD0020D - Currencies maintenance                 */
/*                  FDC0010 - FX and MM rates maintenance            */
/*                  FXC0590 - FX revaluation                         */
/*                  MM0029A - MM revaluation                         */
/*                  TM3300  - FX cross currency maintenance          */
/*                  TMC0110 - FX Takeon                              */
/*                  TMC0210 - MM Takeon                              */
/*                  TMC0310 - AB Takeon                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK009             Date 09Aug99              */
/*       Prev Amend No. E35511            DATE  05FEB92              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       E35511 - Two files not journalled which are required for    */
/*                currencies maintenance (TABTG20 and TABTG40).      */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCLF       FILE(TM0100DD)
 
/*   Declare variables                                               */
             DCL        VAR(&ERRCNT) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSBS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LOGLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LOGSEV) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&LOGTYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LOGCLPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*   Monitor messages                                                */
             MONMSG     MSGID(CPF4101) EXEC(GOTO CMDLBL(SDAFILE))
             MONMSG     MSGID(CPF4131) EXEC(GOTO CMDLBL(SDAFMT))
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(SDAERR))
 
/*   Retrieve job attributes for display                             */
             RTVJOBA    JOB(&WSID) USER(&USER) LOGLVL(&LOGLVL) +
                          LOGSEV(&LOGSEV) LOGTYPE(&LOGTYPE) +
                          LOGCLPGM(&LOGCLPGM)
 
/*   Reset job switches and set logging level                        */
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES) SWS(00000000)
 
/*   Start journalling Treasury Management files                     */
             STRJRNPF   FILE(ABDEALPP FDCCYPPP FDINTRPP FXCRSCPP +
                          FXDEALPP FXDOLMPP FXREVCPP FXREVHPP +
                          MMEPOSPP MMFLIQPP MMFNRDPP MMFWDDPP +
                          MMFWDTPP MMFWDHPP MMLMCYPP MMREVCPP +
                          SDCURRPD SDFCTLPA TABTG10 TABLETA TABLETX +
                          TABG20   TABTG40                  /*E35511*/+
                          FXFWDDPP FXFWDHPP FXEPOSPP) JRN(ICJRN) +
                          IMAGES(*BOTH)
             MONMSG     MSGID(CPF0000)
/************STRCMTCTL  LCKLVL(*CHG)                                      /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                       /*CPK009*/
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&MENUPGMQ) VALUE(TMC0100)
 
 SDABEGIN:   SNDRCVF    DEV(*FILE) RCDFMT(MENUFMT)
 
/*   Remove messages                                                 */
             RMVMSG     CLEAR(*ALL)
 
             IF         COND(&IN03) THEN(DO)
                  GOTO       CMDLBL(SDAEND)
                  ENDDO
 
/*   Option for currencies maintenance                               */
             IF         COND(&OPTION *EQ 1) THEN(DO)
                  CHGJOB SWS(00000000)
                  CHGDTAARA  DTAARA(*LDA) VALUE(' ')
                  CALL       PGM(SD0020D) PARM(' ' 'M')
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                       GOTO       CMDLBL(SDAMSG)
                       ENDDO
                  ENDDO
 
/*   Option for FX rates and points maintenance                      */
             IF         COND(&OPTION *EQ 2) THEN(DO)
                  CHGJOB SWS(00000000)
                  CHGDTAARA  DTAARA(*LDA) VALUE(' ')
                  CALL       PGM(FDC0010) PARM('FD0140')
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                       GOTO       CMDLBL(SDAMSG)
                       ENDDO
                  ENDDO
 
/*   Option for MM interst rates maintenance                         */
             IF         COND(&OPTION *EQ 3) THEN(DO)
                  CHGJOB SWS(00000000)
                  CHGDTAARA  DTAARA(*LDA) VALUE(' ')
                  CALL       PGM(FDC0010) PARM('FD0550')
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                       GOTO       CMDLBL(SDAMSG)
                       ENDDO
                  ENDDO
 
/*   Option for FX cross currency maintenance                        */
             IF         COND(&OPTION *EQ 4) THEN(DO)
                  CHGJOB SWS(00000000)
                  CALL       PGM(TM3300)
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                       GOTO       CMDLBL(SDAMSG)
                       ENDDO
                  ENDDO
 
/*   Option for FX and MM revaluation request                */
             IF         COND(&OPTION *EQ 5) THEN(DO)
                  CHGJOB SWS(00000000)
                  CHGDTAARA  DTAARA(*LDA) VALUE(' ')
                  CALL       PGM(FXC0590)
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                       GOTO       CMDLBL(SDAMSG)
                       ENDDO
                  CALL       PGM(MM0029A)
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                       GOTO       CMDLBL(SDAMSG)
                       ENDDO
                  ENDDO
 
/*   Option for take on of Foreign Exchange deals                    */
             IF         COND(&OPTION *EQ 6) THEN(DO)
                  CHGJOB SWS(00000000)
                  CHGDTAARA  DTAARA(*LDA) VALUE(' ')
                  CALL       PGM(TMC0110)
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                       GOTO       CMDLBL(SDAMSG)
                       ENDDO
                  ENDDO
 
/*   Option for take on of Money Market deals                        */
             IF         COND(&OPTION *EQ 7) THEN(DO)
                  CHGJOB SWS(00000000)
                  CHGDTAARA  DTAARA(*LDA) VALUE(' ')
                  CHGDTAARA  DTAARA(SDSTAT (100 1)) VALUE('1')
                  CHGDTAARA  DTAARA(SDSTAT (100 4)) VALUE('1 0 ')
                  CALL    PGM(TMC0210)
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                       GOTO       CMDLBL(SDAMSG)
                       ENDDO
                  ENDDO
 
/*   Option for take on of Arbitrage deals                           */
             IF         COND(&OPTION *EQ 8) THEN(DO)
                  CHGJOB SWS(00000000)
                  CHGDTAARA  DTAARA(*LDA) VALUE(' ')
                  CALL       PGM(TMC0310)
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                       GOTO       CMDLBL(SDAMSG)
                       ENDDO
                  ENDDO
 
             GOTO       CMDLBL(SDABEGIN)
 
 SDAERR:     IF         COND(&ERRCNT *GT 0) THEN(GOTO CMDLBL(SDAEND))
             CHGVAR     VAR(&ERRCNT) VALUE(&ERRCNT + 1)
 
/*   Handle error messages                                           */
 SDAMSG:     CHGVAR     VAR(&IN01) VALUE('1')
             SNDPGMMSG  MSG('An error has occurred.  Check job log +
                          and/or dump for reason.')
 
             SNDF       DEV(*FILE) RCDFMT(MENUSFLC)
             GOTO       CMDLBL(SDABEGIN)
 
 SDAFILE:    SNDPGMMSG  MSGID(SDA2002) MSGF(QSDAMSG)
             GOTO       CMDLBL(SDAEND)
 
 SDAFMT:     SNDPGMMSG  MSGID(SDA2006) MSGF(QSDAMSG)
 
SDAEND:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CHGJOB     LOG(&LOGLVL &LOGSEV &LOGTYPE) +
                          LOGCLPGM(&LOGCLPGM)
             MONMSG     MSGID(CPF0000)
             ENDJRNPF   FILE(ABDEALPP FDCCYPPP FDINTRPP FXCRSCPP +
                          FXDEALPP FXDOLMPP FXREVCPP FXREVHPP +
                          MMEPOSPP MMFLIQPP MMFNRDPP MMFWDDPP +
                          MMFWDTPP MMFWDHPP MMLMCYPP MMREVCPP +
                          SDCURRPD SDFCTLPA TABTG10 TABLETA TABLETX +
                          FXFWDDPP FXFWDHPP FXEPOSPP) JRN(ICJRN)
             MONMSG     MSGID(CPF0000)
 
             ENDCMTCTL
 
/* If error has occurred then dump program                           */
             IF         COND(&ERRCNT *GT 0) THEN(DO)
                  DMPCLPGM
                  ENDDO
             RETURN
             ENDPGM
