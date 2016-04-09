/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Customer lending COB prompt')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Close of Business Processing                */
/*                                                                   */
/*       EODPLE - LESTAT PROMPTS                                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CAAA03             Date 23Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. E31647             Date 01Oct92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CAAA03 - Webfacing changes.  Re-compiled.                   */
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
             DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCLF       FILE(EODPLEDT) RCDFMT(EODPLE)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CHGVAR     VAR(&PERM) VALUE('Y')
/**/
             RTVJOBA    JOB(&JOB)
             CHGVAR     VAR(&WID) VALUE(%SUBSTRING(&JOB 1 3))
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
/**/
/* SET THE VALUES OF THE CL VARIABLES WHICH CORRESPOND TO PARTS      */
/* OF THE DATA AREA LESTAT                                           */
/**/
             CHGVAR     VAR(&LEACKEY) VALUE(%SUBSTRING(&LESTAT 8 1))
             CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)
/**/
/* DISPLAY THE PROMPT WITH THE OPTIONS WHICH CAN BE TAKEN TO         */
/* UPDATE THE DATA AREA LESTAT TEMPORARILY OR PERMANENTLY.           */
/**/
             SNDRCVF    DEV(*FILE) RCDFMT(*FILE)
/* */                                                                /*E31647*/
/**  If F12 pressed, set &PREV to 'Y'; otherwise set to 'N'       */ /*E31647*/
/* */                                                                /*E31647*/
             IF         COND(&IN12) +
                        THEN(CHGVAR VAR(&PREV) VALUE('Y'))           /*E31647*/
             ELSE       CHGVAR VAR(&PREV) VALUE('N')                 /*E31647*/
/**/
/* DETERMINE IF A TEMPORARY OR PERMANENT UPDATE OF LESTAT HAS BEEN   */
/* REQUESTED.IF ONLY A TEMPORARY UPDATE IS REQUIRED, UPDATE LETEMP   */
/* WITH THE PRESENT LESTAT DATA AREA ELSE UPDATE AFTER.              */
/**/
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
             IF         COND(&PERM *EQ 'N') THEN(DO)
                CHGDTAARA  DTAARA(LETEMP) VALUE(&LESTAT)
             ENDDO
/**/
/* PUT THE REQUIRED VALUES INTO LESTAT TO USE WITHIN EODRUN.IF A     */
/* PERMANENT CHANGE HAS BEEN REQUESTED, THESE VALUES WILL STAY IN    */
/* LESTAT ELSE THE PERMANENT VALUES FROM LETEMP WILL REPLACE THEM    */
/* AFTER TODAYS PROCESSING IN EODRUN IS COMPLETE                     */
/**/
             CHGVAR     VAR(%SUBSTRING(&LESTAT 8 1)) VALUE(&LEACKEY)
/**/
             CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)
/**/
             IF         COND(&PERM *EQ 'Y') THEN(DO)
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
                CHGDTAARA  DTAARA(LETEMP) VALUE(&LESTAT)
             ENDDO
/**/
             ENDPGM
