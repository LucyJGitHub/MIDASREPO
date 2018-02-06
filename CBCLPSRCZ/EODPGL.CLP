/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB GL close of business prompts')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Close of Business Processing                    */
/*                                                                   */
/*       EODPGL - GLSTAT PROMPTS                                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 097827             Date 27Jun96              */
/*                      036796             Date 10Jan94              */
/*                      S01421             DATE 24JUN93              */
/*                      S10736             DATE 29OCT92              */
/*                      E31647             DATE 02OCT92              */
/*                      E25637             DATE 07OCT91              */
/*                      S01290             DATE 14NOV90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*     097827 - COB REPORTING PARAMETERS PROMPT IS DIFFERENT WHEN    */
/*              CALLED FROM INPUT CYCLE AND FROM IC TERM.            */
/*              CALL PROGRAM EODCHK RATHER THAN RETRIEVE FROM CBSTAT */
/*     036796 - IF DL IS NOT INSTALLED PGM STILL LOOKS FOR DLSTAT    */
/*              MOVE SREVAL FLAG FROM DLSTAT TO GLSTAT. REMOVE       */
/*              DECLARATION OF &SREVAL AS IT IS DECLARED IN THE DSPF */
/*              (SUPPLEMENT TO E25637)                               */
/*            - REMOVE F12 (PREV SCREEN) PROCESSING AS GL IS NOW     */
/*              THE FIRST SCREEN DISPLAYED.                          */
/*            - REMOVE REDUNDANT VARIABLES.                          */
/*       S01421 - IN INPUT CYCLE THE PROMPTS ARE TO BE               */
/*                ADDITIONALLY AVAILABLE FROM A SINGLE MENU OPTION.  */
/*                BLI STEP 1 DEVELOPMENT                             */
/*                                                                   */
/*       S10736 - Add print parameter for Management Accounting.     */
/*       E31647 - EOD Prompt Screen bypassed when enter key is       */
/*                pressed by accident. -  Processing for return      */
/*                to previous screen (F12) and parameter &PREV       */
/*                are added.                                         */
/*     E25637 - MOVE PROMPTS FOR 'NOSTROS EVENTS REPORT' AND        */
/*              'EVENTS BY CURRENCY' NUMBER OF DAYS FORWARDS FROM   */
/*              EODPDL TO THIS PROGRAM.                             */
/*     S01290 - MIS GL REPORTING CHANGES                            */
/*                                                                  */
/********************************************************************/
/**/
/*           PGM      */                                              /*S01290*/
/************PGM        PARM(&DL)                                S01290E31647*/
/************PGM        PARM(&DL &PREV ) */                /*E31647*/ /*S01421*/
/************PGM        PARM(&DL &PREV &MODE &EXIT)          /*S01421* *036796*/
             PGM        PARM(&DL &MODE &EXIT)                         /*036796*/
/**/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DL) TYPE(*LGL) LEN(1)                    /*S01290*/
             DCL        VAR(&IN15) TYPE(*LGL) LEN(1)                  /*S01421*/
             DCL        VAR(&IN44) TYPE(*LGL) LEN(1)                  /*S01421*/
/************DCL        VAR(&PREV) TYPE(*CHAR) LEN(1)       */ /*E31647 036796*/
/************DCL        VAR(&IN30) TYPE(*LGL) LEN(1)        */ /*E31647 036796*/
/************DCL        VAR(&IN12) TYPE(*LGL) LEN(1)        */ /*E31647 036796*/
             DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)
/************DCL        VAR(&GLTEMP) TYPE(*CHAR) LEN(256)          */ /*036796*/
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)
/************DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)   */ /*S01290 036796*/
/************DCL        VAR(&CBSTAT) TYPE(*CHAR) LEN(256)     /*S01290* 097827*/
/************DCL        VAR(&CBTYPE) TYPE(*CHAR) LEN(5)       /*S01290* 097827*/
             DCL        VAR(&ACCR) TYPE(*DEC) LEN(1)                  /*097827*/
/************DCL        VAR(&SREVAL) TYPE(*CHAR) LEN(1) VALUE('N')*S0129036796*/
/************DCL        VAR(&NDAYECC) TYPE(*CHAR) LEN(2)    */ /*E25637 036796*/
/************DCL        VAR(&NDAYNEC) TYPE(*CHAR) LEN(2)    */ /*E25637 036796*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*S10736*/
             DCL        VAR(&MCON) TYPE(*CHAR) LEN(1)                 /*S10736*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S10736*/
             DCL        VAR(&FRPR) TYPE(*CHAR) LEN(1)                 /*S10736*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                 /*S01421*/
             DCL        VAR(&EXIT) TYPE(*LGL) LEN(1)                  /*S01421*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,EODPGL003                                           */
/**/
             DCLF       FILE(EODPGLDF)
/* */                                                                /*E31647*/
/****If*DL*present,*allow*F12*processing*                   */ /*E31647 036796*/
/************IF***COND(&DL) THEN(CHGVAR VAR(&IN30) VALUE('1')) /*E31647 036796*/
/**/
/*/COPY WNCPYSRC,EODPGL004                                           */
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)
             CHGVAR     VAR(&RUNA) VALUE(%SUBSTRING(&RUNDAT 1 7))
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGVAR     VAR(&PERM) VALUE('Y')
/**/
             RTVJOBA    JOB(&JOB)
             CHGVAR     VAR(&WID) VALUE(%SUBSTRING(&JOB 1 3))
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)
/************IF         COND(&DL) THEN(RTVDTAARA +
/************           DTAARA(DLSTAT) RTNVAR(&DLSTAT))    /*S01290*/ /*E25637*/
/************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)      */ /*E25637 036796*/
/************RTVDTAARA  DTAARA(CBSTAT) RTNVAR(&CBSTAT)        /*S01290  097827*/
/**/                                                                  /*097827*/
/* CALL EODCHK TO DETERMINE ACCRUAL TYPE */                           /*097827*/
/* INSTEAD OF USING DTAARA CBSTAT */                                  /*097827*/
/**/                                                                  /*097827*/
             CALL       PGM(EODCHK) PARM(&ACCR)                       /*097827*/
/**/                                                                  /*097827*/
/**/
/* SET THE VALUES OF THE CL VARIABLES WHICH CORRESPOND TO PARTS      */
/* OF THE DATA AREA GLSTAT                                           */
/**/
             CHGVAR     VAR(&MOVI) VALUE(%SUBSTRING(&GLSTAT 69 1))
             IF         COND(&MOVI *EQ ' ') THEN(CHGVAR +
                          VAR(&MOVI) VALUE('N'))                      /*S01290*/
/**/                                                                  /*S01290*/
             CHGVAR     VAR(&DSIND1) VALUE(%SUBSTRING(&GLSTAT 70 1))  /*S01290*/
             IF         COND(&DSIND1 *EQ ' ') THEN(CHGVAR +
                          VAR(&DSIND1) VALUE('D'))                    /*S01290*/
/**/                                                                  /*S01290*/
             CHGVAR     VAR(&DSIND2) VALUE(%SUBSTRING(&GLSTAT 71 1))  /*S01290*/
             IF         COND(&DSIND2 *EQ ' ') THEN(CHGVAR +
                          VAR(&DSIND2) VALUE('D'))                    /*S01290*/
/**/                                                                  /*S01290*/
             CHGVAR     VAR(&DSIND3) VALUE(%SUBSTRING(&GLSTAT 72 1))  /*S01290*/
             IF         COND(&DSIND3 *EQ ' ') THEN(CHGVAR +
                          VAR(&DSIND3) VALUE('D'))                    /*S01290*/
/**/                                                                  /*S01290*/
             CHGVAR     VAR(&DSIND4) VALUE(%SUBSTRING(&GLSTAT 73 1))  /*S01290*/
             IF         COND(&DSIND4 *EQ ' ') THEN(CHGVAR +
                          VAR(&DSIND4) VALUE('D'))                    /*S01290*/
/**/                                                                  /*S10736*/
             CHGVAR     VAR(&FRPR) VALUE(%SUBSTRING(&GLSTAT 89 1))    /*S10736*/
             IF         COND(&FRPR *EQ ' ') THEN(CHGVAR +
                          VAR(&FRPR) VALUE('N'))                      /*S10736*/
/**/                                                                  /*S01290*/
/*   DETERMINE TYPE OF COB RUN AND WHETHER SPOT REVALS REQUIRED       /*S01290*/
/**/                                                                  /*S01290*/
/************CHGVAR     VAR(&CBTYPE) VALUE(%SUBSTRING(&CBSTAT+**/
/************           46 5))                                 /*S01290 097827*/
/************IF         COND(&DL) THEN(CHGVAR VAR(&SREVAL) +
/************           VALUE(%SUBSTRING(&DLSTAT 14 1)))       /*S01290 036796*/
             CHGVAR     VAR(&SREVAL) VALUE(%SST(&GLSTAT 35 1))        /*036796*/
/**/                                                                  /*036796*/
/************IF         COND(&CBTYPE *NE 'THREE') THEN(CHGVAR +
                          VAR(&IN01) VALUE('1'))              /*S01290  097827*/
             IF         COND(&ACCR *NE 3) THEN(CHGVAR +
                          VAR(&IN01) VALUE('1'))                      /*097827*/
/**/                                                                  /*S01290*/
/************IF         COND(&CBTYPE *NE 'ONE  ') THEN(CHGVAR +
                          VAR(&IN02) VALUE('1'))               *S01290  097827*/
             IF         COND(&ACCR *NE 1) THEN(CHGVAR +
                          VAR(&IN02) VALUE('1'))                      /*097827*/
/**/                                                                  /*S01290*/
/************IF         COND(&SREVAL *EQ 'N') THEN(CHGVAR VAR(&IN03) +
/************             VALUE('1'))                          /*S01290 036796*/
/**/                                                                  /*S01290*/
/************IF         COND(&CBTYPE *EQ 'ONE  ') THEN(CHGVAR +
                          VAR(&IN04) VALUE('1'))              /*S01290  097827*/
             IF         COND(&ACCR *EQ 1) THEN(CHGVAR +
                          VAR(&IN04) VALUE('1'))                      /*097827*/
/**/                                                                  /*E25637*/
/* SET THE VALUES OF THE CL VARIABLES WHICH CORRESPOND TO PARTS */    /*E25637*/
/* OF THE DATA AREA GLSTAT                                      */    /*036796*/
/**OF*THE*DATA*AREA*DLSTAT*******                         */   /*E25637 036796*/
/**/                                                                  /*E25637*/
/************CHGVAR  VAR(&NDAYNE) VALUE(%SUBSTRING(&DLSTAT 8 2)) E25637 036796*/
/************CHGVAR  VAR(&NDAYEC) VALUE(%SUBSTRING(&DLSTAT 10 2))E25637 036796*/
             CHGVAR  VAR(&NDAYNE) +
                     VALUE(%SUBSTRING(&GLSTAT 31 2))                  /*036796*/
             CHGVAR  VAR(&NDAYEC) +
                     VALUE(%SUBSTRING(&GLSTAT 33 2))                  /*036796*/
/**/                                                                  /*S10736*/
/*  DETERMINE IF MANAGEMENT ACCOUNTS MODULE IS SWITCHED ON  */        /*S10736*/
/*  IN SDMMODPD POSITION 95 */                                        /*S10736*/
/**/                                                                  /*S10736*/
             CHGVAR     VAR(&RTCD) VALUE('*DBERR ')                   /*S10736*/
             CALL       PGM(AOMMODR0) PARM(&RTCD '*FIRST' &DSFDY)     /*S10736*/
             CHGVAR VAR(&MCON) VALUE(%SST(&DSFDY 95 1))               /*S10736*/
/**/                                                                  /*S10736*/
/*  IF THE MANAGEMENT ACCOUNTS MODULE IS SWITCHED ON  */              /*S10736*/
             IF         COND(&MCON *EQ 'Y') THEN(CHGVAR VAR(&IN05) +
                          VALUE('1'))                                 /*S10736*/
/**/
/*  IF COB PROMPTS DISPLAYED IN I/C, ALLOW F3 FROM GL SCREEN ONLY      *036796*/
/*   IF DEALING NOT INSTALLED.                                         *036796*/
             IF     COND(&MODE *EQ 'I' *AND &DL *NE '1') THEN(CHGVAR +
                      (&IN44) VALUE('1'))                             /*S01421*/
/**/
/* DISPLAY THE PROMPT WITH THE OPTIONS WHICH CAN BE TAKEN TO         */
/* UPDATE THE DATA AREA GLSTAT TEMPORARILY OR PERMANENTLY.           */
/**/
/*/COPY WNCPYSRC,EODPGL001                                           */
             SNDRCVF    DEV(*FILE) RCDFMT(*FILE)
/* */                                                                /*E31647*/
             IF    COND(&IN44 *AND &IN15 *EQ '1') THEN(DO)            /*S01421*/
                   CHGVAR VAR(&EXIT) VALUE('1')                       /*S01421*/
                   GOTO ENDPGM                                        /*S01421*/
               ENDDO                                                  /*S01421*/
/*/COPY WNCPYSRC,EODPGL005                                           */
/**/                                                                  /*S01421*/
/****If*DL*present*and*F12*pressed,*set*&PREV*to*'Y'********/ /*E31647 036796*/
/****otherwise,*set*&PREV*to*'N'****************************/ /*E31647 036796*/
/* */                                                                /*E31647*/
/************IF         COND(&IN30 *AND &IN12) +                     /*036796*/
/************           THEN(CHGVAR VAR(&PREV) VALUE('Y')) */ /*E31647 036796*/
/************ELSE       CHGVAR VAR(&PREV) VALUE('N')       */ /*E31647 036796*/
/**/
/* DETERMINE IF A TEMPORARY OR PERMANENT UPDATE OF GLSTAT HAS BEEN   */
/* REQUESTED.  IF ONLY A TEMPORARY UPDATE IS REQUIRED, UPDATE GLTEMP */
/* WITH THE PRESENT GLSTAT DATA AREA, ELSE UPDATE AFTER.             */
/**/
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)
             IF         COND(&PERM *EQ 'N') THEN(DO)
                CHGDTAARA  DTAARA(GLTEMP) VALUE(&GLSTAT)
             ENDDO
/**/
/*/COPY WNCPYSRC,EODPGL002                                           */
/* PUT THE REQUIRED VALUES INTO GLSTAT TO USE WITHIN COB.  IF A      */
/* PERMANENT CHANGE HAS BEEN REQUESTED, THESE VALUES WILL STAY IN    */
/* GLSTAT, ELSE THE PERMANENT VALUES FROM GLTEMP WILL REPLACE THEM   */
/* AFTER TODAY'S PROCESSING IN COB IS COMPLETE                       */
/**/
             CHGVAR     VAR(%SUBSTRING(&GLSTAT 69 1)) VALUE(&MOVI)
/**/                                                                  /*S01290*/
/* UPDATE GLSTAT WITH THE VALUES ENTERED ON THE SCREEN                /*S01290*/
/**/                                                                  /*S01290*/
             CHGVAR     VAR(%SUBSTRING(&GLSTAT 31 2)) VALUE(&NDAYNE)  /*036796*/
             CHGVAR     VAR(%SUBSTRING(&GLSTAT 33 2)) VALUE(&NDAYEC)  /*036796*/
             CHGVAR     VAR(%SUBSTRING(&GLSTAT 35 1)) VALUE(&SREVAL)  /*036796*/
             CHGVAR     VAR(%SUBSTRING(&GLSTAT 70 1)) VALUE(&DSIND1)  /*S01290*/
             CHGVAR     VAR(%SUBSTRING(&GLSTAT 71 1)) VALUE(&DSIND2)  /*S01290*/
             CHGVAR     VAR(%SUBSTRING(&GLSTAT 72 1)) VALUE(&DSIND3)  /*S01290*/
             CHGVAR     VAR(%SUBSTRING(&GLSTAT 73 1)) VALUE(&DSIND4)  /*S01290*/
             CHGVAR     VAR(%SUBSTRING(&GLSTAT 89 1)) VALUE(&FRPR)    /*S10736*/
/**/
             CHGDTAARA  DTAARA(GLSTAT) VALUE(&GLSTAT)
/**/                                                                  /*E25637*/
/**UPDATE*DLSTAT*WITH*THE*VALUES*ENTERED*ON*THE*SCREEN***      /*E25637 036796*/
/**/                                                                  /*E25637*/
/************CHGVAR VAR(%SUBSTRING(&DLSTAT 8 2))  VALUE(&NDAYNE) E25637 036796*/
/************CHGVAR VAR(%SUBSTRING(&DLSTAT 10 2)) VALUE(&NDAYEC) E25637 036796*/
/**/                                                                  /*E25637*/
/************CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)          /*E25637 036796*/
/**/
             IF         COND(&PERM *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)
                CHGDTAARA  DTAARA(GLTEMP) VALUE(&GLSTAT)
/***************CHGVAR     VAR(&NDAYNEC) VALUE(&NDAYNE)     */ /*E25637 036796*/
/***************CHGVAR     VAR(&NDAYECC) VALUE(&NDAYEC)     */ /*E25637 036796*/
/***************CHGDTAARA  DTAARA(DLTEMP (8 2)) VALUE(&NDAYNEC)/*E25637 036796*/
/***************CHGDTAARA  DTAARA(DLTEMP (10 2)) VALUE(&NDAYECC)*E25637 036796*/
             ENDDO
/**/
                                                                      /*S01421*/
/*********** ENDPGM */                                                /*S01421*/
ENDPGM:      ENDPGM                                                   /*S01421*/
