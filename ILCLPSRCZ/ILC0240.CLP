/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Routing keys maintenance selection')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       CLP/ILC0240  - Routing keys maintenance selection           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. TLIFIX             Date 14Jun02              */
/*                      ULX043             Date 25Jun01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       TLIFIX - Dtaara BLSTAT is not used anymore.                 */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/***  Declare Data for display at selection screen.  ***/
 
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATUM) TYPE(*CHAR) LEN(7)
 
/***  Declare variable for testing allowed modules.  ***/
 
             DCL        VAR(&DL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DN) TYPE(*CHAR) LEN(1)
 
/***  Call RPG pgm --> reset selection.  ***/
 
             DCL        VAR(&CALL) TYPE(*CHAR) LEN(1)
 
/***  Display file.  ***/
 
             DCLF       FILE(ILC0240DF) RCDFMT(ILC0240X0)
 
/***  Retrieve job information (standard display)  ***/
 
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&JOB) VALUE('ILC0240')
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&DATUM)
 
/***  Read allowed modules.  ***/
 
/*** TLIFIX Begin ***/
/************RTVDTAARA  DTAARA(BLSTAT (3 1)) RTNVAR(&DL)     ******/
/************RTVDTAARA  DTAARA(BLSTAT (3 1)) RTNVAR(&DN)     ******/
/************RTVDTAARA  DTAARA(BLSTAT (5 1)) RTNVAR(&LE)     ******/
/************RTVDTAARA  DTAARA(BLSTAT (6 1)) RTNVAR(&SE)     ******/
/************RTVDTAARA  DTAARA(BLSTAT (7 1)) RTNVAR(&FT)     ******/
/************RTVDTAARA  DTAARA(BLSTAT (8 1)) RTNVAR(&FF)     ******/
 
             RTVDTAARA  DTAARA(ILSTAT (14 1)) RTNVAR(&DL)
             RTVDTAARA  DTAARA(ILSTAT (14 1)) RTNVAR(&DN)
             RTVDTAARA  DTAARA(ILSTAT (15 1)) RTNVAR(&LE)
             RTVDTAARA  DTAARA(ILSTAT (16 1)) RTNVAR(&SE)
             RTVDTAARA  DTAARA(ILSTAT (17 1)) RTNVAR(&FT)
             RTVDTAARA  DTAARA(ILSTAT (18 1)) RTNVAR(&FF)
/*** TLIFIX End ***/
 
/***  If module is usable, set on flag to display  ***/
 
             IF         COND(&DL *NE 'Y') THEN(CHGVAR VAR(&IN11) +
                          VALUE('1'))
             IF         COND(&DN *NE 'Y') THEN(CHGVAR VAR(&IN12) +
                          VALUE('1'))
             IF         COND(&LE *NE 'Y') THEN(CHGVAR VAR(&IN13) +
                          VALUE('1'))
             IF         COND(&SE *NE 'Y') THEN(CHGVAR VAR(&IN14) +
                          VALUE('1'))
             IF         COND(&FT *NE 'Y') THEN(CHGVAR VAR(&IN15) +
                          VALUE('1'))
             IF         COND(&FF *NE 'Y') THEN(CHGVAR VAR(&IN16) +
                          VALUE('1'))
 
/***  Read choice ***/
 
 SCREEN:     SNDRCVF    RCDFMT(ILC0240X0)
 
/***  Reset external switches.  ***/
 
 RUN:        CHGJOB     SWS(XXXXXX00)
 
/***  Reset internal switch.  ***/
 
             CHGVAR     VAR(&CALL) VALUE(' ')
 
/***  Cmd03 goto end   --*/
 
             IF         COND(&IN03) THEN(GOTO CMDLBL(ENDPGM))
 
/***  Acces allowed to Dealing module ***/
 
             IF         COND((&OPTION *EQ '1') *AND (&DL *EQ 'Y')) +
                          THEN(DO)
 
/*** change U1 switch to specifiate use of file  ***/
 
             CHGJOB     SWS(0XXXXXXX)
 
/***  Override file.  ***/
 
             OVRDBF     FILE(ILRKDLXX) TOFILE(ILRKDLPD) SHARE(*NO)
 
/***  Call program.  ***/
 
             CHGVAR     VAR(&CALL) VALUE('1')
             CALL       PGM(IL0240) PARM(' ')
 
/***  Monitor for Error msg from system.  ***/
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
 
/***  Send Message to user alerting failure.  ***/
 
             SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                          Enter to continue.') TOPGMQ(*EXT)
 
/***  Execute DUMP program  ***/
 
             DMPCLPGM
 
/***  by pass rest of the processing  ***/
 
             GOTO       CMDLBL(ENDPGM)
             ENDDO
             ENDDO
 
 
/***  Acces allowed to Dealing module for Assets maintenance ***/
 
             IF         COND((&OPTION *EQ '2') *AND (&DN *EQ 'Y')) +
                          THEN(DO)
 
/*** change U1 switch to specifiate use of file  ***/
 
             CHGJOB     SWS(1XXXXXXX)
 
/***  Override file.  ***/
 
             OVRDBF     FILE(ILRKDLXX) TOFILE(ILRKDLPD) SHARE(*NO)
 
/***  Call program.  ***/
 
             CHGVAR     VAR(&CALL) VALUE('1')
             CALL       PGM(IL0240) PARM(' ')
 
/***  Monitor for Error msg from system.  ***/
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
 
/***  Send Message to user alerting failure.  ***/
 
             SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                          Enter to continue.') TOPGMQ(*EXT)
 
/***  Execute DUMP program  ***/
 
             DMPCLPGM
 
/***  by pass rest of the processing  ***/
 
             GOTO       CMDLBL(ENDPGM)
             ENDDO
             ENDDO
 
/***  Acces allowed to Lending module ***/
 
             IF         COND((&OPTION *EQ '3') *AND (&LE *EQ 'Y')) +
                          THEN(DO)
 
/***  Override file.  ***/
 
             OVRDBF     FILE(ILRKLEXX) TOFILE(ILRKLEPD) SHARE(*NO)
 
/***  Call program.  ***/
 
             CHGVAR     VAR(&CALL) VALUE('1')
             CALL       PGM(IL0241) PARM(' ')
 
/***  Monitor for Error msg from system.  ***/
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
 
/***  Send Message to user alerting failure.  ***/
 
             SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                          Enter to continue.') TOPGMQ(*EXT)
 
/***  Execute DUMP program  ***/
 
             DMPCLPGM
 
/***  by pass rest of the processing  ***/
 
             GOTO       CMDLBL(ENDPGM)
             ENDDO
             ENDDO
 
/***  Acces allowed to Security module ***/
 
             IF         COND((&OPTION *EQ '4') *AND (&SE *EQ 'Y')) +
                          THEN(DO)
 
/***  Override file.  ***/
 
             OVRDBF     FILE(ILRKSEXX) TOFILE(ILRKSEPD) SHARE(*NO)
 
/***  Call program.  ***/
 
             CHGVAR     VAR(&CALL) VALUE('1')
             CALL       PGM(IL0243) PARM(' ')
 
/***  Monitor for Error msg from system.  ***/
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
 
/***  Send Message to user alerting failure.  ***/
 
             SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                          Enter to continue.') TOPGMQ(*EXT)
 
/***  Execute DUMP program  ***/
 
             DMPCLPGM
 
/***  by pass rest of the processing  ***/
 
             GOTO       CMDLBL(ENDPGM)
             ENDDO
             ENDDO
 
/***  Acces allowed to Funds transfer module ***/
 
             IF         COND((&OPTION *EQ '5') *AND (&FT *EQ 'Y')) +
                          THEN(DO)
 
/***  Override file.  ***/
 
             OVRDBF     FILE(ILRKFTXX) TOFILE(ILRKFTPD) SHARE(*NO)
 
/***  Call program.  ***/
 
             CHGVAR     VAR(&CALL) VALUE('1')
             CALL       PGM(IL0244) PARM(' ')
 
/***  Monitor for Error msg from system.  ***/
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
 
/***  Send Message to user alerting failure.  ***/
 
             SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                          Enter to continue.') TOPGMQ(*EXT)
 
/***  Execute DUMP program  ***/
 
             DMPCLPGM
 
/***  by pass rest of the processing  ***/
 
             GOTO       CMDLBL(ENDPGM)
             ENDDO
             ENDDO
 
/***  Acces allowed to Futures and options module ***/
 
             IF         COND((&OPTION *EQ '6') *AND (&FF *EQ 'Y')) +
                          THEN(DO)
 
/***  Override file.  ***/
 
             OVRDBF     FILE(ILRKFFXX) TOFILE(ILRKFFPD) SHARE(*NO)
 
/***  Call program.  ***/
 
             CHGVAR     VAR(&CALL) VALUE('1')
             CALL       PGM(IL0245) PARM(' ')
 
/***  Monitor for Error msg from system.  ***/
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
 
/***  Send Message to user alerting failure.  ***/
 
             SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                          Enter to continue.') TOPGMQ(*EXT)
 
/***  Execute DUMP program  ***/
 
             DMPCLPGM
 
/***  by pass rest of the processing  ***/
 
             GOTO       CMDLBL(ENDPGM)
             ENDDO
             ENDDO
 
 
             IF         COND(&CALL *EQ '1') THEN(DO)
 
/***  Reset selection.  ***/
 
             CHGVAR     VAR(&OPTION) VALUE(' ')
 
             ENDDO
 
             GOTO       SCREEN
 
 ENDPGM:     CHGVAR     VAR(&ACTCPY) VALUE('(c) Misys International +
                            Banking Systems Ltd. 2005')
 
             ENDPGM
