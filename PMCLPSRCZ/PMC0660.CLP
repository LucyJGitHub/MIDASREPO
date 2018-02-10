/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Search and Select Function')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0660  - CONTROLLING WINDOW                               */
/*                                                                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPM005             Date 01Jul96              */
/*                      081239             Date 03Feb95              */
/*                      S01486             DATE 07JUL94             */
/*                      066296             DATE 08DEC93             */
/*                      R05605             DATE 06/03/91            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase 2                           */
/*                Focus Group Changes upgraded to DBA               */
/*                PBFG/7 - NET COMMITMENT BY CURRENCY               */
/*                PBFG/8 - DISPLAY POSITIONS SPLIT BY CURRENCY      */
/*       081239 - R10 Private Banking Rework                         */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       066296 - CALL PMC0670 INSTEAD OF PM0670 ELSE MESSAGE FILE   */
/*                OVERRIDES ARE NOT ACTIONED.                        */
/*       R05505 - RESET ENQUIRIES TERMINATING INDICATOR ON DTAARA/*GDA*/
/*                BEFORE TRANSFERRING TO PGM/PM0670                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/* PGM        PARM(&F12)                                              /*CPM005*/
 PGM        PARM(&F12 &INDIC)                                         /*CPM005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 /*                                                       */
 /* DECLARE VARIABLES                                     */
             DCL        VAR(&F12) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENQT) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)               * *081239*/
             DCL        VAR(&RTRN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&INDIC) TYPE(*CHAR) LEN(1)                /*CPM005*/
/*S01486 BEGIN*/
/*********** DCL        VAR(&GROUP) TYPE(*CHAR) LEN(10) +
                          VALUE('SCROLL    ')                           S01486*/
/*S01486 END*/
/***RETRIEVE*JOB*ATTRIBUTES******************************************* *081239*/
/************RTVGRPA    GRPJOB(&JOBN)                                * *081239*/
 /* INITIALIZE PARAMETERS                                 */
             CHGVAR     VAR(&F12) VALUE(' ')
             CHGVAR     VAR(&RTRN) VALUE(' ')
 /* CALL PM0660 TO DISPLAY SEARCH AND SELECT WINDOW       */
/************CALL       PGM(PM0660) PARM(&JOBN &F12 &RTRN)           * *081239*/
/************CALL       PGM(PM0660) PARM(&F12 &RTRN)         *081239* /*CPM005*/
             CALL       PGM(PM0660) PARM(&F12 &RTRN &INDIC)           /*CPM005*/
 /* TEST IF F12 SET TO 'Y'                                */
             IF         COND(&F12 *NE 'Y') THEN(DO)
 /* TEST IF SCROLL SCREEN REQUESTED                       */
             IF         COND(&RTRN *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&RTRN) VALUE(' ')
 /********** CHGDTAARA  DTAARA(*GDA (1 1)) VALUE(' ')          /*R05605 S01486*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*S01486*/
 /********** TFRGRPJOB  GRPJOB(&GROUP) INLGRPPGM(PM0670) ***/ /*066296*/
 /********** TFRGRPJOB  GRPJOB(&GROUP) INLGRPPGM(PMC0670)      /*066296 S01486*/
 /* TEST IF CURRENCY ENTERED ON WINDOW PM0630 */                      /*CPM005*/
             IF         COND(&F12 *EQ 'C') THEN(DO)                   /*CPM005*/
             CALL       PGM(PM0671)                                   /*CPM005*/
             ENDDO                                                    /*CPM005*/
             ELSE (DO)                                                /*CPM005*/
             CALL       PGM(PM0670)                                   /*S01486*/
             ENDDO                                                    /*CPM005*/
 /* RETRIEVE DATA AREA *GDA */
 /********** RTVDTAARA  DTAARA(*GDA (1 1)) RTNVAR(&ENQT)                S01486*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*S01486*/
             IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'C') THEN(DO)
 /********** CALL       PGM(PMC1020)                                  /*S01486*/
             RETURN                                                   /*S01486*/
             ENDDO
 /*                         */
             ENDDO
             ENDDO
 /********** ENDPGM                                                  */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ENDPGM
