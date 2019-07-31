/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Futures and options COB prompt')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Close of Business Processing                */
/*                                                                   */
/*       EODPFF - FFSTAT PROMPTS                                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAAA03             Date 23Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E31647             Date 01Oct92              */
/*                      S01127             Date 22Jun88              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAAA03 - Webfacing changes.  Re-compiled.                   */
/*       E31647 - EOD Prompt Screen bypassed when enter key is       */
/*                pressed by accident. -  Processing for return      */
/*                to previous screen (F12) and parameter &PREV       */
/*                are added.                                         */
/*       S01127  -  FF INCORPORATION CHANGE                         *  *S01127*/
/*                                                                  */
/********************************************************************/
/**/
/************PGM */                                                  /*E31467*/
             PGM        PARM(&PREV)                                  /*E31647*/
/**/
             DCL        VAR(&JOB) TYPE(*CHAR)  LEN(10)
             DCL        VAR(&PREV) TYPE(*CHAR) LEN(1)                /*E31647*/
             DCL        VAR(&IN12) TYPE(*LGL) LEN(1)                 /*E31647*/
             DCL        VAR(&FFSTAT) TYPE(*CHAR)  LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCLF       FILE(EODPFFDT) RCDFMT(EODPFF)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGVAR     VAR(&PERM) VALUE('Y')
/**/
             RTVJOBA    JOB(&JOB)
             CHGVAR     VAR(&WID) VALUE(%SST(&JOB 1 3))
             RTVDTAARA  DTAARA(FFSTAT) RTNVAR(&FFSTAT)
/**/
/*  SET THE VALUE OF THE CL VARIABLE FROM VALUE IN D/FFSTAT         */
/**/
             CHGVAR     VAR(&FFACKEY) VALUE(%SST(&FFSTAT 10 1))
/**/
/*  DISPLAY THE PROMPT WITH OPTIONS WHICH CAN BE TAKEN TO UPDATE    */
/*  THE DATA AREA FFSTAT TEMPORARILY OR PERMANENTLY.                */
/**/
             SNDRCVF    DEV(*FILE) RCDFMT(*FILE)
/* */                                                                /*E31647*/
/**  If F12 pressed, set &PREV to 'Y'; otherwise set to 'N'       */ /*E31647*/
/* */                                                                /*E31647*/
             IF         COND(&IN12) +
                        THEN(CHGVAR VAR(&PREV) VALUE('Y'))           /*E31647*/
             ELSE       CHGVAR VAR(&PREV) VALUE('N')                 /*E31647*/
/**/
/*  DETERMINE IF A TEMPORARY OR PERMANENT UPDATE OF FFSTAT HAS BEEN */
/*  REQUESTED. IF ONLY A TEMP. UPDATE IS REQUIRED UPDATE D/FFTEMP   */
/*  WITH THE PRESENT D/FFSTAT, ELSE UPDATE D/FFTEMP AFTER CHANGING  */
/*  D/FFSTAT                                                        */
/**/
             IF         COND(&PERM = 'N') THEN(+
                CHGDTAARA  DTAARA(FFTEMP) VALUE(&FFSTAT))
/**/
/*  PUT THE REQUIRED VALUE INTO FFSTAT TO USE WITHIN EODRUN. IF A   */
/*  PERMANENT CHANGE HAS BEEN REQUESTED IT WILL STAY IN FFSTAT, ELSE*/
/*  THE PERMANENT VALUE FROM FFTEMP WILL REPLACE IT AFTER TODAYS    */
/*  PROCESSING IN EODRUN IS COMPLETE                                */
/**/
             CHGDTAARA  DTAARA(FFSTAT (10 1))  VALUE(&FFACKEY)
/**/
/*           IF         COND(&PERM = 'Y') THEN(+
                CHGDTAARA  DTAARA(FFTEMP) VALUE(&FFSTAT))   */        /*S01127*/
             IF         COND(&PERM = 'Y') THEN(DO)                    /*S01127*/
             RTVDTAARA  DTAARA(FFSTAT) RTNVAR(&FFSTAT)                /*S01127*/
                CHGDTAARA  DTAARA(FFTEMP) VALUE(&FFSTAT)              /*S01127*/
             ENDDO                                                    /*S01127*/
/**/
             ENDPGM
