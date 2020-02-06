/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB DL close of business prompts')               */
/********************************************************************/
/*                                                                  */
/*  Midas - Close of Business Processing                    */
/*                                                                  */
/*  EODPDL - DLSTAT PROMPTS                                         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAAA03             Date 23Mar04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAS001             Date 23Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      054545             Date 24Feb94              */
/*                      036796             Date 10Jan94              */
/*                    S01421            DATE   24JUN93              */
/*                    E25637            DATE   07OCT91              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CAAA03 - Webfacing changes.  Re-compiled.                   */
/*       CAS001 - Net Present Value (NPV) Accounting                */
/*  054545  -  Forward Revals Posted should be pos.23 of DLSTAT     */
/*             according to the PF/DLSTAT layout                    */
/*             Also the two Forward Reval fields were wrong way     */
/*             round in display file. &FREVAL now = run forward     */
/*             revals, &FREVLP now = post forward revals            */
/*  036796  -  REMOVE SREVAL(POS. 14) PROMPTS AND MOVE IT TO EODPGL */
/*             (SUPPLEMENT TO E25637)                               */
/*          -  APPLY E31647 TO THIS PROGRAM ALSO (ALLOW F12 - PREV) */
/*          -  ALSO REMOVE VARIABLES NOT REFERENCED                 */
/*  S01421  -  IN INPUT CYCLE THE PROMPTS ARE TO BE ADDITIONALLY    */
/*             AVAILABLE FROM A SINGLE MENU OPTION. BLI STEP 1      */
/*             DEVELOPMENT                                          */
/*                                                                  */
/*  E25637  -  REMOVE PROMPTS FOR 'NOSTROS EVENTS REPORT' AND       */
/*             'EVENTS BY CURRENCY' NUMBER OF DAYS FORWARDS AND     */
/*             MOVE THEM TO EODPGL.                                 */
/*                                                                  */
/********************************************************************/
/*********** PGM */                                                   /*S01421*/
/*********** PGM        PARM(&MODE &EXIT)                      /*S01421 036796*/
             PGM        PARM(&MODE &EXIT &PREV)                       /*036796*/
/**/
             DCL        VAR(&EXIT) TYPE(*LGL) LEN(1)                  /*S01421*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                 /*S01421*/
             DCL        VAR(&PREV) TYPE(*CHAR) LEN(1)                 /*036796*/
             DCL        VAR(&IN12) TYPE(*LGL) LEN(1)                  /*036796*/
             DCL        VAR(&IN14) TYPE(*LGL) LEN(1)                  /*S01421*/
             DCL        VAR(&IN33) TYPE(*LGL) LEN(1)                  /*S01421*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&CORRUPT) TYPE(*LGL) LEN(1)            */ /*036796*/
             DCL        VAR(&NDTRIX) TYPE(*DEC) LEN(5)
/************DCL        VAR(&DILIB) TYPE(*CHAR) LEN(7)          +  */ /*036796*/
/************             VALUE('  DILIB')                         */ /*036796*/
/*/COPY WNCPYSRC,EODPDL001                                           */
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                                                          /*CAS001*/
/* Declare variables used for CAS001 */                                                   /*CAS001*/
                                                                                          /*CAS001*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7)                                     /*CAS001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CAS001*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CAS001*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)                                   /*CAS001*/
             DCL        VAR(&CAS001) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CAS001*/
/**/
             DCLF       FILE(EODPDLDT) RCDFMT(EODPDL)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGVAR     VAR(&PERM) VALUE('Y')
                                                                                          /*CAS001*/
/* Initialise variables for AOSARDR0 */                                                   /*CAS001*/
                                                                                          /*CAS001*/
             CHGVAR VAR(&RTNC) VALUE('       ')                                           /*CAS001*/
             CHGVAR VAR(&SARD) VALUE('CAS001')                                            /*CAS001*/
             CHGVAR VAR(&OPTN) VALUE('*VERIFY')                                           /*CAS001*/
                                                                                          /*CAS001*/
/* Call AOSARDR0 to check if Switchable CAS001 is switched on */                          /*CAS001*/
                                                                                          /*CAS001*/
             CALL   PGM(AOSARDR0) PARM(&RTNC &OPTN &SARD &SFMT)                           /*CAS001*/
                                                                                          /*CAS001*/
             IF     COND(&RTNC *EQ '       ') THEN(CHGVAR +
                      VAR(&CAS001) VALUE('Y'))                                            /*CAS001*/
             IF     COND(&CAS001 *EQ 'Y' *AND &PREV *EQ 'Y') +
                      THEN(DO)                                                            /*CAS001*/
                        CHGVAR VAR(&PREV) VALUE(' ')                                      /*CAS001*/
                        GOTO PREV2                                                        /*CAS001*/
                      ENDDO                                                               /*CAS001*/
/**/
             RTVJOBA    JOB(&JOB)
             CHGVAR     VAR(&WID) VALUE(%SUBSTRING(&JOB 1 3))
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
/**/
/* SET THE VALUES OF THE CL VARIABLES WHICH CORRESPOND TO PARTS      */
/* OF THE DATA AREA DLSTAT                                           */
/**/
             CHGVAR     VAR(&NDTRIX) VALUE(%SUBSTRING(&DLSTAT 1 5))
/************CHGVAR     VAR(&NDAYNE) VALUE(%SUBSTRING(&DLSTAT 8 2))   /*E25637*/
/************CHGVAR     VAR(&NDAYEC) VALUE(%SUBSTRING(&DLSTAT 10 2))  /*E25637*/
/**/
/**/
/**/
/*   SET UP PROMPT SCREEN                                           */
/**/
/************CHGVAR     VAR(&SREVAL) VALUE(%SUBSTRING(&DLSTAT 14 1))  /*036796*/
             CHGVAR     VAR(&DLACKEY) VALUE(%SUBSTRING(&DLSTAT 15 1))
             CHGVAR     VAR(&FREVAL) VALUE(%SUBSTRING(&DLSTAT 16 1))
/**/
/*********** CHGVAR     VAR(&FREVLP) VALUE(%SUBSTRING(&DLSTAT 24 1))  /*054545*/
             CHGVAR     VAR(&FREVLP) VALUE(%SUBSTRING(&DLSTAT 23 1))  /*054545*/
/**/
             CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)
/*/COPY WNCPYSRC,EODPDL002                                           */
/**/
PREV:                                                                                     /*CAS001*/
             IF    COND(&MODE *EQ 'I') THEN(CHGVAR +
                     (&IN14) VALUE('1'))                           /*S01421*/
/**/
/* DISPLAY THE PROMPT WITH THE OPTIONS WHICH CAN BE TAKEN TO         */
/* UPDATE THE DATA AREA DLSTAT TEMPORARILY OR PERMANENTLY.           */
/**/
             SNDRCVF    DEV(*FILE) RCDFMT(*FILE)
/**/                                                                  /*S01421*/
             IF    COND(&IN33 *AND &IN14 *EQ '1') THEN(DO)            /*S01421*/
                   CHGVAR VAR(&EXIT) VALUE('1')                       /*S01421*/
                   GOTO ENDCLPGM                                      /*S01421*/
               ENDDO                                                  /*S01421*/
/* */                                                                 /*036796*/
/**  If F12 pressed, set &PREV to 'Y'                              */ /*036796*/
/**  otherwise, set &PREV to 'N'                                   */ /*036796*/
             IF         COND(&IN12) +
                        THEN(CHGVAR VAR(&PREV) VALUE('Y'))            /*036796*/
             ELSE       CHGVAR VAR(&PREV) VALUE('N')                  /*036796*/
/**/
/* DETERMINE IF A TEMPORARY OR PERMANENT UPDATE OF DLSTAT HAS BEEN   */
/* REQUESTED.IF ONLY A TEMPORARY UPDATE IS REQUIRED, UPDATE DLTEMP   */
/* WITH THE PRESENT DLSTAT DATA AREA ELSE UPDATE AFTER.              */
/**/
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
             IF         COND(&PERM *EQ 'N') THEN(DO)
                CHGDTAARA  DTAARA(DLTEMP) VALUE(&DLSTAT)
             ENDDO
/**/
/* PUT THE REQUIRED VALUES INTO DLSTAT TO USE WITHIN EODRUN.IF A     */
/* PERMANENT CHANGE HAS BEEN REQUESTED, THESE VALUES WILL STAY IN    */
/* DLSTAT ELSE THE PERMANENT VALUES FROM DLTEMP WILL REPLACE THEM    */
/* AFTER TODAYS PROCESSING IN EODRUN IS COMPLETE                     */
/**/
/************CHGVAR     VAR(%SUBSTRING(&DLSTAT 8 2))  VALUE(&NDAYNE)  /*E25637*/
/************CHGVAR     VAR(%SUBSTRING(&DLSTAT 10 2)) VALUE(&NDAYEC)  /*E25637*/
/************CHGVAR     VAR(%SUBSTRING(&DLSTAT 14 1)) VALUE(&SREVAL)  /*036796*/
             CHGVAR     VAR(%SUBSTRING(&DLSTAT 15 1)) VALUE(&DLACKEY)
             CHGVAR     VAR(%SUBSTRING(&DLSTAT 16 1)) VALUE(&FREVAL)
/**/
/*********** CHGVAR     VAR(%SUBSTRING(&DLSTAT 24 1)) VALUE(&FREVLP)  /*054545*/
             CHGVAR     VAR(%SUBSTRING(&DLSTAT 23 1)) VALUE(&FREVLP)  /*054545*/
/**/
             CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)
/**/
             IF         COND(&PERM *EQ 'Y') THEN(DO)
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
                CHGDTAARA  DTAARA(DLTEMP) VALUE(&DLSTAT)
             ENDDO
/*/COPY WNCPYSRC,EODPDL003                                           */
                                                                                          /*CAS001*/
PREV2:                                                                                    /*CAS001*/
             IF         COND(&CAS001 *EQ 'Y' *AND &PREV *NE 'Y') +
                          THEN(DO)                                                        /*CAS001*/
                                                                                          /*CAS001*/
/* Initialise variables for DL000900 */                                                   /*CAS001*/
                                                                                          /*CAS001*/
               CHGVAR     VAR(&RTNC) VALUE('       ')                                     /*CAS001*/
               CALL       PGM(DL000900) PARM(&RTNC)                                       /*CAS001*/
               IF         COND(&RTNC *EQ 'PREV') THEN(GOTO +
                            CMDLBL(PREV))                                                 /*CAS001*/
               IF         COND(&RTNC *EQ 'EXIT') THEN(CHGVAR +
                            VAR(&EXIT) VALUE('1'))                                        /*CAS001*/
                                                                                          /*CAS001*/
             ENDDO                                                                        /*CAS001*/
                                                                                          /*CAS001*/
ENDCLPGM:    ENDPGM
