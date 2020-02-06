/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Securities trading COB prompt')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Close of Business Processing                */
/*                                                                   */
/*       EODPSE - SESTAT PROMPTS                                     */
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
/*       Prev Amend No. S01502             Date 08Jul94              */
/*                      E31647             Date 06Oct92              */
/*                      17737              DATE 05/04/89             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*                change in length of SESTAT, 133 long.              */
/*       E31647 - EOD prompt screen bypassed when ENTER key is       */
/*                pressed by accident. - Processing for return       */
/*                to previous screen (F12) and parameter &PREV       */
/*                are added.                                         */
/*       E17737 - OBJECT MISSING FROM R1 & SESTAT WRONG LENGTH       */
/*                                                                   */
/*********************************************************************/
/**/
/************PGM */                                                  /*E31647*/
             PGM        PARM(&PREV)                                  /*E31647*/
/**/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREV) TYPE(*CHAR) LEN(1)                /*E31647*/
             DCL        VAR(&IN12) TYPE(*LGL) LEN(1)                 /*E31647*/
/************DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(128)*/           /*S01502*/
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)             /*S01502*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCLF       FILE(EODPSEDT) RCDFMT(EODPSE)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGVAR     VAR(&PERM) VALUE('Y')
/**/
             RTVJOBA    JOB(&JOB)
             CHGVAR     VAR(&WID) VALUE(%SUBSTRING(&JOB 1 3))
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
/**/
/*   SET UP PROMPT SCREEN                                           */
/**/
             CHGVAR     VAR(&SEACKEY) VALUE(%SUBSTRING(&SESTAT 5 1))
/**/
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
/**/
/* DISPLAY THE PROMPT WITH THE OPTIONS WHICH CAN BE TAKEN TO         */
/* UPDATE THE DATA AREA SESTAT TEMPORARILY OR PERMANENTLY.           */
/**/
             SNDRCVF    DEV(*FILE) RCDFMT(*FILE)
/* */                                                                /*E31647*/
/**  If F12 is pressed, set &PREV to 'Y'; otherwise set to 'N'    */ /*E31647*/
/* */                                                                /*E31647*/
             IF         COND(&IN12) +
                        THEN(CHGVAR VAR(&PREV) VALUE('Y'))           /*E31647*/
             ELSE       CHGVAR VAR(&PREV) VALUE('N')                 /*E31647*/
/**/
/* DETERMINE IF A TEMPORARY OR PERMANENT UPDATE OF SESTAT HAS BEEN   */
/* REQUESTED.IF ONLY A TEMPORARY UPDATE IS REQUIRED, UPDATE SETEMP   */
/* WITH THE PRESENT SESTAT DATA AREA ELSE UPDATE AFTER.              */
/**/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
             IF         COND(&PERM *EQ 'N') THEN(DO)
                CHGDTAARA  DTAARA(SETEMP) VALUE(&SESTAT)
             ENDDO
/**/
/* PUT THE REQUIRED VALUES INTO SESTAT TO USE WITHIN EODRUN.IF A     */
/* PERMANENT CHANGE HAS BEEN REQUESTED, THESE VALUES WILL STAY IN    */
/* SESTAT ELSE THE PERMANENT VALUES FROM SETEMP WILL REPLACE THEM    */
/* AFTER TODAYS PROCESSING IN EODRUN IS COMPLETE                     */
/**/
             CHGVAR     VAR(%SUBSTRING(&SESTAT 5 1)) VALUE(&SEACKEY)
/**/
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
/**/
             IF         COND(&PERM *EQ 'Y') THEN(DO)
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
                CHGDTAARA  DTAARA(SETEMP) VALUE(&SESTAT)
             ENDDO
ENDCLPGM:    ENDPGM
