/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Midas information screen')                   */
/*********************************************************************/
/*                                                                   */
/*      Midas - System Control Module                                */
/*                                                                   */
/*      SCC0010 - DISPLAY MIDAS INFORMATION SCREEN                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*      Last Amend No. CPK018                Date 23Feb04            */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*      Prev Amend No. S01345                Date 01Nov91            */
/*                     S01343                Date 15Aug91            */
/*                     E26655                Date 08Aug91            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      CPK018 - MidasPlus packaging.  Remove use of RUNDAT.         */
/*      S01345  -  NEW STANDARD FORMAT (OPTION2) ADDED.              */
/*      S01343  -  SC/RR/SD MODULE RENAME PROJECT.                   */
/*                 - L1BGIN RENAMED TO SCBEGIN.                      */
/*                 - L1MNUD10 RENAMED TO SCMENUD.                    */
/*                 - MBACKUP RENAMED TO SCBACKUP.                    */
/*                 - RRTTERM RENAMED TO SCRRTTERM.                   */
/*                 - SDC0606 RENAMED TO SCC0606.                     */
/*                 - SDC05 RENAMED TO SCC05.                         */
/*                 - SDC07 RENAMED TO SCC07.                         */
/*                 - SDC01 RENAMED TO SCC01.                         */
/*      E26655  -  Rewrite the SC Midas Information Screen system    */
/*                 to use MSGF/MIDASMSG in all cases.                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FPGM &SCREEN &REPLY1)
 
             DCL        VAR(&SCREEN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MIDASMSG) TYPE(*CHAR) LEN(800)
             DCL        VAR(&IN01) TYPE(*LGL)
             DCL        VAR(&IN02) TYPE(*LGL)
             DCL        VAR(&IN03) TYPE(*LGL)
             DCL        VAR(&IN04) TYPE(*LGL)
             DCL        VAR(&IN05) TYPE(*LGL)
             DCL        VAR(&IN06) TYPE(*LGL)
             DCL        VAR(&IN07) TYPE(*LGL)
             DCL        VAR(&IN08) TYPE(*LGL)
             DCL        VAR(&IN09) TYPE(*LGL)
             DCL        VAR(&IN10) TYPE(*LGL)
             DCL        VAR(&IN11) TYPE(*LGL)
             DCL        VAR(&IN12) TYPE(*LGL)
             DCL        VAR(&IN13) TYPE(*LGL)
             DCL        VAR(&IN14) TYPE(*LGL)
             DCL        VAR(&IN15) TYPE(*LGL)
             DCL        VAR(&IN16) TYPE(*LGL)
             DCL        VAR(&IN17) TYPE(*LGL)
             DCL        VAR(&IN18) TYPE(*LGL)
             DCL        VAR(&IN19) TYPE(*LGL)
             DCL        VAR(&IN20) TYPE(*LGL)
             DCL        VAR(&IN21) TYPE(*LGL)
             DCL        VAR(&IN22) TYPE(*LGL)
             DCL        VAR(&IN23) TYPE(*LGL)
             DCL        VAR(&IN24) TYPE(*LGL)
             DCL        VAR(&IN25) TYPE(*LGL)
             DCL        VAR(&IN26) TYPE(*LGL)
             DCL        VAR(&IN27) TYPE(*LGL)
             DCL        VAR(&IN28) TYPE(*LGL)
             DCL        VAR(&IN29) TYPE(*LGL)
             DCL        VAR(&IN30) TYPE(*LGL)
             DCL        VAR(&IN31) TYPE(*LGL)
             DCL        VAR(&IN32) TYPE(*LGL)
             DCL        VAR(&IN33) TYPE(*LGL)
             DCL        VAR(&IN34) TYPE(*LGL)
             DCL        VAR(&IN35) TYPE(*LGL)
             DCL        VAR(&IN36) TYPE(*LGL)
             DCL        VAR(&IN37) TYPE(*LGL)
             DCL        VAR(&IN38) TYPE(*LGL)
             DCL        VAR(&IN39) TYPE(*LGL)
             DCL        VAR(&IN40) TYPE(*LGL)
             DCL        VAR(&IN41) TYPE(*LGL)
             DCL        VAR(&IN42) TYPE(*LGL)
             DCL        VAR(&IN43) TYPE(*LGL)
             DCL        VAR(&IN44) TYPE(*LGL)
             DCL        VAR(&IN45) TYPE(*LGL)
             DCL        VAR(&IN46) TYPE(*LGL)
             DCL        VAR(&IN47) TYPE(*LGL)
             DCL        VAR(&IN48) TYPE(*LGL)
             DCL        VAR(&IN49) TYPE(*LGL)
             DCL        VAR(&IN50) TYPE(*LGL)
             DCLF       FILE(SCC0010DF)
/*/COPY WNCPYSRC,SCC0010001                                          */
 
/*  COPYRIGHT STATEMENT VARIABLE  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*  RETRIEVE INDICATOR SETTINGS FROM DTAARA/MIDASMSG  */
 
             RTVDTAARA  DTAARA(MIDASMSG) RTNVAR(&MIDASMSG)
 
/*  REFLECT FOR ANY INDICATORS SET ON IN DTAARA/MIDASMSG  */
 
             IF         COND(%SST(&MIDASMSG 1 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN01) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 2 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN02) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 3 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN03) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 4 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN04) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 5 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN05) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 6 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN06) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 7 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN07) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 8 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN08) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 9 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN09) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 10 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN10) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 11 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN11) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 12 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN12) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 13 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN13) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 14 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN14) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 15 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN15) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 16 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN16) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 17 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN17) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 18 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN18) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 19 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN19) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 20 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN20) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 21 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN21) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 22 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN22) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 23 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN23) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 24 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN24) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 25 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN25) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 26 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN26) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 27 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN27) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 28 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN28) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 29 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN29) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 30 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN30) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 31 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN31) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 32 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN32) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 33 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN33) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 34 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN34) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 35 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN35) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 36 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN36) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 37 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN37) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 38 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN38) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 39 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN39) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 40 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN40) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 41 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN41) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 42 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN42) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 43 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN43) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 44 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN44) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 45 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN45) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 46 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN46) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 47 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN47) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 48 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN48) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 49 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN49) VALUE('1'))
             IF         COND(%SST(&MIDASMSG 50 1) *EQ '1') +
                          THEN(CHGVAR VAR(&IN50) VALUE('1'))
 
/*  RETRIEVE & FORMAT MESSAGE  */
 
             CALL       PGM(SCC0011) PARM(&LINE1 &LINE2 &LINE3 +
                          &LINE4 &LINE5 &LINE6 &LINE7 &LINE8 &LINE9 +
                          &LINE10 &REPLY1)
 
/*  SEND HEADER/TRAILER INFORMATION  */
 
/**********  RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&DATE)                             */ /*CPK018*/
             RTVJOBA    JOB(&WSID) USER(&USER)
             SNDF       RCDFMT(HEADER)
             SNDF       RCDFMT(TRAILER)
 
/*  SEND MESSAGE TO SCREEN  */
 
             SNDF       RCDFMT(MIDASMSG)
 
/**  BLANK  **/
 
             IF         COND(&SCREEN *EQ 'BLANK') THEN(DO)
                SNDF       RCDFMT(BLANK)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  ENTER  **/
 
             IF         COND(&SCREEN *EQ 'ENTER') THEN(DO)
                SNDRCVF    RCDFMT(ENTER)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  JOBLOG  **/
 
             IF         COND(&SCREEN *EQ 'JOBLOG') THEN(DO)
                SNDRCVF    RCDFMT(JOBLOG)
                IF         COND(&REPLY1 *EQ 'Y') THEN(DO)
                   DSPJOB     OPTION(*JOBLOG)
                ENDDO
                GOTO       CMDLBL(END)
             ENDDO
 
/**  OPTION  **/
 
             IF         COND(&SCREEN *EQ 'OPTION') THEN(DO)
                SNDRCVF    RCDFMT(OPTION)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  OPTION2  **/                                                     /*S01345*/
                                                                      /*S01345*/
             IF         COND(&SCREEN *EQ 'OPTION2') THEN(DO)          /*S01345*/
                SNDRCVF    RCDFMT(OPTION2)                            /*S01345*/
                GOTO       CMDLBL(END)                                /*S01345*/
             ENDDO                                                    /*S01345*/
                                                                      /*S01345*/
/**  RETRY  **/
 
             IF         COND(&SCREEN *EQ 'RETRY') THEN(DO)
                SNDRCVF    RCDFMT(RETRY)
                GOTO       CMDLBL(END)
             ENDDO
 
/*  END OF PROGRAM PROCESSING  */
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             CHGDTAARA  DTAARA(MIDASMSG (1 99)) VALUE(' ')
 
             ENDPGM
