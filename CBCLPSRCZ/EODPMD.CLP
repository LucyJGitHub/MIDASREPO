/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB COB reporting prompts control')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Close of Business Processing                */
/*                                                                   */
/*       EODPMD - END OF DAY DATA AREA REPORTING PROMPTS             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CAS001             Date 23Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 18Jun96              */
/*                      036796             Date 10Jan94              */
/*                      S01421             DATE 23JUN93              */
/*                      E31647             DATE 05OCT92              */
/*                      S01290             DATE 14NOV90              */
/*                      S01281             DATE 04/07/90             */
/*                      S01189             DATE 04/04/89            *  *S03220*/
/*                      S01127             DATE 02/06/88            *  *S03220*/
/*                      S03220             DATE 13/05/88            *  *S03220*/
/*                      S01129             DATE 21/07/87            *  *S01129*/
/*                                                                  */
/*********************************************************************/
/*                                                                   */
/*       CAS001 - Net Present Value (NPV) Accounting                 */
/*       S01408 -  Core hook EODPMD001 added.                       */
/*       036796  -  PROMPTS FOR NOSTROS EVENTS REPORT & EVENTS BY   */
/*                  CCY NO. OF DAYS FORWARD, AND SPOT REVAL. WERE   */
/*                  MOVED FROM EODPGL TO EODPDL.                    */
/*               -  ALSO, E31647 AMENDED SO GL CALLED FIRST AND IS  */
/*                  CALLED ONCE ONLY, AND ALL OTHER SCREENS HAVE    */
/*                  F12 FUNCTION TO GO BACK TO PREV SCREEN          */
/*       S01421 - THE INPUT CYCLE PROMPTS TO BE AVAILABLE FROM       */
/*                A SINGLE MENU OPTION - BLI STEP 1 DEVELOPMENT      */
/*       E31647 - EOD Prompt Screen bypassed when enter key is       */
/*                pressed by accident. -  Processing for return      */
/*                to previous screen (F12) and parameter &PREV       */
/*                are added.                                         */
/*       S01290  -  EODPGL MUST BE CALLED AFTER EODPDL              */
/*       S01281  -  ACCESS GLSTAT FOR STATEMENT CONTROL - CALL      */
/*                  PROGRAM TO UPDATE GLSTAT                        */
/*       S01189  -  CLOSE OF BUSINESS ENHANCEMENTS PHASE 2          */
/*       S01127  -  FUTURES AND OPTIONS INCORPORATION               */
/*       S03220  -   FUNDS TRANSFER                                 *  *S03220*/
/*       S01129  -   SECURITIES TRADING RELEASE 2                   *  *S01129*/
/*                                                                  */
/********************************************************************/
/**/
/*****       PGM        PARM(&DL &CL &RT &LE &BC &ST)               *  *S01129*/
/*           PGM        PARM(&DL &CL &RT &LE &BC &ST &SE)      S01129   S03220*/
/*           PGM   PARM(&DL &CL &RT &LE &BC &ST &SE &FT) */ /*S03220*  *S01127*/
/********    PGM        PARM(&DL &CL &RT &LE &BC &ST &SE &FT &FF)/*S01127*/
/********    PGM        PARM(&DL &CL &LE &SE &FT &FF)      /*S01189*/ /*S01421*/
             PGM        PARM(&MODE)                                   /*S01421*/
/**/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(128)               /*S01421*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                 /*S01421*/
             DCL        VAR(&EXIT) TYPE(*LGL) LEN(1)                  /*S01421*/
             DCL        VAR(&DL)  TYPE(*LGL)  LEN(1)
/********    DCL        VAR(&RT)  TYPE(*LGL)  LEN(1)                  /*S01189*/
/********    DCL        VAR(&CL)  TYPE(*LGL)  LEN(1)                  /*036796*/
             DCL        VAR(&LE)  TYPE(*LGL)  LEN(1)
/********    DCL        VAR(&BC)  TYPE(*LGL)  LEN(1)                  /*S01189*/
/********    DCL        VAR(&ST)  TYPE(*LGL)  LEN(1)                  /*S01189*/
             DCL        VAR(&SE)  TYPE(*LGL)  LEN(1)                  /*S01129*/
             DCL        VAR(&FT)  TYPE(*LGL)  LEN(1)                  /*S03220*/
             DCL        VAR(&FF)  TYPE(*LGL)  LEN(1)                  /*S01127*/
             DCL        VAR(&PREV) TYPE(*CHAR) LEN(1)                /*E31647*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)                /*E31647*/
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)               /*E31647*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CALL       PGM(AOMMODR0) PARM('*DBERR ' '*FIRST ' +
                          &MMOD)                                      /*S01421*/
/**/
             IF         COND(%SUBSTRING(&MMOD 23 1) *EQ Y) +
                          THEN(CHGVAR VAR(&DL) VALUE('1'))            /*S01421*/
/**/
             IF         COND(%SUBSTRING(&MMOD 48 1) *EQ Y) +
                          THEN(CHGVAR VAR(&DL) VALUE('1'))            /*S01421*/
/**/
             IF         COND(%SUBSTRING(&MMOD 28 1) *EQ Y) +
                          THEN(CHGVAR VAR(&LE) VALUE('1'))            /*S01421*/
/**/
             IF         COND(%SUBSTRING(&MMOD 31 1) *EQ Y) +
                          THEN(CHGVAR VAR(&SE) VALUE('1'))            /*S01421*/
/**/
             IF         COND(%SUBSTRING(&MMOD 39 1) *EQ Y) +
                          THEN(CHGVAR VAR(&FT) VALUE('1'))            /*S01421*/
/**/
             IF         COND(%SUBSTRING(&MMOD 41 1) *EQ Y) +
                          THEN(CHGVAR VAR(&FF) VALUE('1'))            /*S01421*/
/**/
/**/                                                                  /*S01281*/
/* CALL PROGRAM TO UPDATE ZERO BALANCE/NO MOVEMENT FLAG*/ /*S01290*/  /*S01281*/
/* FLAG ON GLSTAT  */                                   /*S01290*/    /*S01281*/
/**/                                                                  /*S01281*/
/*           CALL PGM(EODPGL)      */   /*S01290*/                    /*S01281*/
/**/                                                                  /*S01281*/
/**/
/* Decide which data areas are valid to be prompted for and call     */
/* correct CL program.                                               */
/************IF         COND(&DL) THEN(CALL PGM(EODPDL)) */          /*E31647*/
/**/                                                                  /*S01290*/
/************CALL PGM(EODPGL)  PARM(&DL)                         SO1290E31647*/
/**/
/************IF         COND(&CL) THEN(CALL PGM(EODPCL)) */          /*E31647*/
/**/
/************IF         COND(&LE) THEN(CALL PGM(EODPLE)) */          /*E31647*/
/**/
/********    IF         COND(&BC) THEN(CALL PGM(EODPBC))              /*S01189*/
/**/
/********    IF         COND(&ST) THEN(CALL PGM(EODPST))              /*S01189*/
/**/
/************IF         COND(&SE) THEN(CALL PGM(EODPSE))         S01290E31647*/
/**/
/************IF         COND(&FT) THEN(CALL PGM(EODPFT))         S01290E31647*/
/**/
/************IF         COND(&FF) THEN(CALL PGM(EODPFF))         S01290E31647*/
/**/                                                                  /*S01127*/
/* */                                                                /*E31647*/
/**  Call GL Prompt                                               */ /*036796*/
GL_TAG:      CALL       PGM(EODPGL) PARM(&DL &MODE &EXIT)            /*036796*/
             IF         COND(&EXIT *EQ '1') THEN(GOTO ENDPGM)        /*036796*/
             CHGVAR     VAR(&PREV) VALUE('N')                                             /*CAS001*/
                                                                     /*036796*/
/**  Call DL Prompt if module present                             */ /*E31647*/
/* */                                                                /*E31647*/
/*DL_TAG:    IF         COND(&DL) THEN(CALL PGM(EODPDL))  /*E31647*/ /*S01421*/
/*DL_TAG:****IF         COND(&DL) THEN(CALL PGM(EODPDL) PARM(&MODE +
/************             &EXIT))                             /*S01421 036796*/
DL_TAG:      IF         COND(&DL) THEN(CALL PGM(EODPDL) PARM(&MODE +
                          &EXIT &PREV))                              /*036796*/
             IF         COND(&PREV='Y') THEN(GOTO CMDLBL(GL_TAG))    /*036796*/
/**/
             IF         COND(&EXIT *EQ '1') THEN(GOTO ENDPGM)        /*S01421*/
/* */                                                                /*E31647*/
/****Call*GL*Prompt****                                     */ /*E31647 036796*/
/* */                                                                /*E31647*/
/*GL_TAG     CALL       PGM(EODPGL) PARM(&DL &PREV)  */   /*E31647*/ /*S01421*/
/*GL_TAG:****CALL       PGM(EODPGL) PARM(&DL &PREV &MODE &EXIT)*S01421 036796*/
/************IF         COND(&EXIT *EQ '1') THEN(GOTO ENDPGM) /*S01421 036796*/
/************IF         COND(&PREV='Y') THEN(GOTO CMDLBL(DL_TAG))E31647036796*/
/**/
/* */                                                                /*E31647*/
/**  Call LE Prompt if module present                             */ /*E31647*/
/**  then go back to CL Prompt if F12 pressed                     */ /*E31647*/
/* */                                                                /*E31647*/
LE_TAG:      IF         COND(&LE) THEN(DO)                           /*E31647*/
                  CALL       PGM(EODPLE) PARM(&PREV)                 /*E31647*/
/*****************IF         COND(&PREV='Y') +
/*****************           THEN(GOTO CMDLBL(GL_TAG))        /*E31647 036796*/
                  ENDDO                                              /*E31647*/
/**                                                               */ /*036796*/
/**          If F12 was pressed, go to previous prompt.           */ /*036796*/
             IF         COND(&PREV = 'Y') THEN(GOTO CMDLBL(DL_TAG))  /*036796*/
/* */                                                                /*E31647*/
/* */                                                                /*E31647*/
/************Else module not present                       */ /*E31647 036796*/
/************If F12 was previously pressed, go to CL Prompt*/ /*E31647 036796*/
/* */                                                                /*E31647*/
/************ELSE                                             /*E31647 036796*/
/*****************IF COND(&PREV='Y') THEN(GOTO CMDLBL(GL_TAG))/*E31647 036796*/
/* */                                                                /*E31647*/
/**  Call SE Prompt if module present                             */ /*E31647*/
/**  then go back to LE Prompt if F12 pressed                     */ /*E31647*/
/* */                                                                /*E31647*/
SE_TAG:      IF         COND(&SE) THEN(DO)                           /*E31647*/
                  CALL       PGM(EODPSE) PARM(&PREV)                 /*E31647*/
                  IF         COND(&PREV='Y') +
                             THEN(GOTO CMDLBL(LE_TAG))               /*E31647*/
                  ENDDO                                              /*E31647*/
/* */                                                                /*E31647*/
/**          Else module not present                              */ /*E31647*/
/**          If F12 was previously pressed, go to LE Prompt       */ /*E31647*/
/* */                                                                /*E31647*/
             ELSE                                                    /*E31647*/
                  IF COND(&PREV='Y') THEN(GOTO CMDLBL(LE_TAG))       /*E31647*/
/* */                                                                /*E31647*/
/**  Call FT Prompt if module present                             */ /*E31647*/
/**  then go back to SE Prompt if F12 pressed                     */ /*E31647*/
/* */                                                                /*E31647*/
FT_TAG:      IF         COND(&FT) THEN(DO)                           /*E31647*/
                  CALL       PGM(EODPFT) PARM(&PREV)                 /*E31647*/
                  IF         COND(&PREV='Y') +
                             THEN(GOTO CMDLBL(SE_TAG))               /*E31647*/
                  ENDDO                                              /*E31647*/
/* */                                                                /*E31647*/
/**          Else module not present                              */ /*E31647*/
/**          If F12 was previously pressed, go to SE Prompt       */ /*E31647*/
/* */                                                                /*E31647*/
             ELSE                                                    /*E31647*/
                  IF COND(&PREV='Y') THEN(GOTO CMDLBL(SE_TAG))       /*E31647*/
/* */                                                                /*E31647*/
/**  Call FF Prompt if module present                             */ /*E31647*/
/**  then go back to FT Prompt if F12 pressed                     */ /*E31647*/
/* */                                                                /*E31647*/
FF_TAG:      IF         COND(&FF) THEN(DO)                           /*E31647*/
                  CALL       PGM(EODPFF) PARM(&PREV)                 /*E31647*/
                  IF         COND(&PREV='Y') +
                             THEN(GOTO CMDLBL(FT_TAG))               /*E31647*/
                  ENDDO                                              /*E31647*/
/* */                                                                /*E31647*/
/**          Else module not present                              */ /*E31647*/
/**          If F12 was previously pressed, go to FT Prompt       */ /*E31647*/
/* */                                                                /*E31647*/
             ELSE                                                    /*E31647*/
                  IF COND(&PREV='Y') THEN(GOTO CMDLBL(FT_TAG))       /*E31647*/
/* */                                                                /*E31647*/
/**  Display confirmation screen                                  */ /*E31647*/
/* */                                                                /*E31647*/
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,EODPMD001                                           /*S01408*/
/*                                                                   /*S01408*/
             IF    COND(&MODE='C') THEN(DO)                          /*S01421*/
/**/
             RTVMSG     MSGID(CBM0006) MSGF(MIDASMSG) MSG(&MSG)      /*E31647*/
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MSG)        /*E31647*/
             CHGVAR     VAR(&MSG) VALUE(' ')                         /*E31647*/
             RTVMSG     MSGID(CBM0007) MSGF(MIDASMSG) MSG(&MSG)      /*E31647*/
             CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MSG)        /*E31647*/
             CHGVAR     VAR(&MSG) VALUE(' ')                         /*E31647*/
             RTVMSG     MSGID(CBM0008) MSGF(MIDASMSG) MSG(&MSG)      /*E31647*/
             CHGDTAARA  DTAARA(MIDASMSG (451 50)) VALUE(&MSG)        /*E31647*/
             CHGVAR     VAR(&MSG) VALUE(' ')                         /*E31647*/
             CHGDTAARA  DTAARA(MIDASMSG (4 1)) VALUE('1')            /*E31647*/
             CHGVAR     VAR(&REPLY) VALUE('N')                       /*S01421*/
             CALL       PGM(CBC0700) PARM('EODPMD' 'OPTION' &REPLY)  /*E31647*/
/* */                                                                /*E31647*/
/**  Return to FF Prompt if reply is 'N'                          */ /*E31647*/
/* */                                                                /*E31647*/
             IF         COND(&REPLY *EQ 'N' *OR &REPLY *EQ 'n') +
                        THEN(DO)                                     /*E31647*/
                  CHGVAR     VAR(&PREV) VALUE('Y')                   /*E31647*/
                  CHGVAR     VAR(&REPLY) VALUE(' ')                  /*E31647*/
                  GOTO       CMDLBL(FF_TAG)                          /*E31647*/
                  ENDDO                                              /*E31647*/
                  ENDDO                                              /*S01421*/
/* */                                                                /*E31647*/
/*********** ENDPGM */                                                /*S01421*/
ENDPGM:      ENDPGM                                                   /*S01421*/
