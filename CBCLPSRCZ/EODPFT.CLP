/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Funds transfer COB run option')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Close of Business Processing                */
/*                                                                   */
/*       EODPFT - FTSTAT PROMPTS                                     */
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
/*       Prev Amend No. E31647             Date 01Oct92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       E31647 - EOD Prompt Screen bypassed when enter key is       */
/*                pressed by accident. -  Processing for return      */
/*                to previous screen (F12) and parameter &PREV       */
/*                are added.                                         */
/*                                                                   */
/*********************************************************************/
/**/
/************PGM */                                                  /*E31647*/
             PGM        PARM(&PREV)                                  /*E31647*/
/**/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREV) TYPE(*CHAR) LEN(1)                /*E31647*/
             DCL        VAR(&IN12) TYPE(*LGL) LEN(1)                 /*E31647*/
             DCL        VAR(&FTSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCLF       FILE(EODPFTDF) RCDFMT(EODPFT)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGVAR     VAR(&PERM) VALUE('Y')
/**/
             RTVJOBA    JOB(&JOB)
             CHGVAR     VAR(&WID) VALUE(%SUBSTRING(&JOB 1 3))
             RTVDTAARA  DTAARA(FTSTAT) RTNVAR(&FTSTAT)
/**/
/*   SET UP PROMPT SCREEN                                           */
/**/
             CHGVAR     VAR(&FTACKEY) VALUE(%SUBSTRING(&FTSTAT 5 1))
/**/
/* DISPLAY THE PROMPT WITH THE OPTIONS WHICH CAN BE TAKEN TO         */
/* UPDATE THE DATA AREA FTSTAT TEMPORARILY OR PERMANENTLY.           */
/**/
             SNDRCVF    DEV(*FILE) RCDFMT(*FILE)
/* */                                                                /*E31647*/
/**  If F12 pressed, set &PREV to 'Y'; otherwise set to 'N'       */ /*E31647*/
/* */                                                                /*E31647*/
             IF         COND(&IN12) +
                        THEN(CHGVAR VAR(&PREV) VALUE('Y'))           /*E31647*/
             ELSE       CHGVAR VAR(&PREV) VALUE('N')                 /*E31647*/
/**/
/* DETERMINE IF A TEMPORARY OR PERMANENT UPDATE OF FTSTAT HAS BEEN   */
/* REQUESTED.IF ONLY A TEMPORARY UPDATE IS REQUIRED, UPDATE FTTEMP   */
/* WITH THE PRESENT FTSTAT DATA AREA ELSE UPDATE AFTER.              */
/**/
             RTVDTAARA  DTAARA(FTSTAT) RTNVAR(&FTSTAT)
             IF         COND(&PERM *EQ 'N') THEN(DO)
                CHGDTAARA  DTAARA(FTTEMP) VALUE(&FTSTAT)
             ENDDO
/**/
/* PUT THE REQUIRED VALUES INTO FTSTAT TO USE WITHIN EODRUN.IF A     */
/* PERMANENT CHANGE HAS BEEN REQUESTED, THESE VALUES WILL STAY IN    */
/* FTSTAT ELSE THE PERMANENT VALUES FROM FTTEMP WILL REPLACE THEM    */
/* AFTER TODAYS PROCESSING IN EODRUN IS COMPLETE                     */
/**/
             CHGVAR     VAR(%SUBSTRING(&FTSTAT 5 1)) VALUE(&FTACKEY)
/**/
             CHGDTAARA  DTAARA(FTSTAT) VALUE(&FTSTAT)
/**/
             IF         COND(&PERM *EQ 'Y') THEN(DO)
             RTVDTAARA  DTAARA(FTSTAT) RTNVAR(&FTSTAT)
                CHGDTAARA  DTAARA(FTTEMP) VALUE(&FTSTAT)
             ENDDO
ENDCLPGM:    ENDPGM
