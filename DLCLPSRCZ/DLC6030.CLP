/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Start of day reorganisation')                */
/*********************************************************************/
/*                                                                   */
/*     Midas - Dealing Module                                        */
/*                                                                   */
/*     DLC6030 - START  OF DAY REORGANISATION                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG6177            Date 19Apr05              */
/*                      CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                     134471       Date 30Apr98                     */
/*                     S01495       DATE 01OCT94                     */
/*                     S01319       DATE 13JAN92                     */
/*                     S01319       DATE  9OCT91                     */
/*                     BH1054       DATE 27AUG91                     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*    BG18886 - Amend non-standard codes.                            */
/*       BUG6177 - Unecessary delay in DLC6030                       */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*    134471 - Change parm on call of AOMMODR0 from @RTCD to blank   */
/*           - and remove declare of '&RTCD'                         */
/*    S01495 - COB Enhancements.                                     */
/*    S01319  -  (HY0039) AOMMODR0 called with incorrect parameter   */
/*    S01319 -   Remove redundant processing                         */
/*    BH1054  -  RESET HAS PROBLEM WHEN SWITCHES ARE ON.             */
/*                                                                   */
/*********************************************************************/
 
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&WWSUBN) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&WWSUBNA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWFLGS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWSUBE1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWSUBE2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWSUBE3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWCALL)  TYPE(*CHAR) LEN(26)
             DCL        VAR(&WWERR) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(50)
/**/
/****VARIABLE*IS*USED*TO*CHECK*FOR*EXISTENCE*OF*MODULES*FX,*MM*****/ /*S01319*/
/****AND*AB.*******************************************************/ /*S01319*/
/**/
/************DCL********VAR(&FX)*TYPE(*CHAR)*LEN(1)*VALUE(N)*******/ /*S01319*/
/************DCL********VAR(&MM)*TYPE(*CHAR)*LEN(1)*VALUE(N)********/ /*S01319*/
/*   VARIABLE IS USED TO CHECK FOR EXISTENCE OF MODULE  AB        */ /*S01319*/
             DCL        VAR(&AB) TYPE(*CHAR) LEN(1) VALUE(N)
/************DCL********VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(N)***     /*134471*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE(*FIRST)   /*S01319*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200) VALUE(N)       /*S01319*/
/**/
/************DCL********VAR(&MMOD)*TYPE(*CHAR)*LEN(256)*************/ /*S01319*/
/*           DCLF       FILE(DLC6030DD)                                 S01495*/
/**/                                                                  /*BH1054*/
             CHGJOB     SWS(00000000)                                 /*BH1054*/
/**/
/*   MONITOR ALL MESSAGES NOT TRAPPED IN THE REST OF THE PROGRAM     */
/**/
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(TAG998))
/**/
/* DISPLAY MIDAS SCREEN                                           */
/**/
/*           CHGVAR     VAR(&MSG1) VALUE('Start of Day Reorganisation')S01495*/
/*           SNDF       RCDFMT(MIDASWAIT1)                             S01495*/
/*           SNDF       RCDFMT(MIDASWAIT2)                             S01495*/
/**/
/* SET TSTATUS TO 'DRSRECOV' DURING EXECUTION, TSTATUS WILL BE    */
/* RESET TO 'NORMAL' AT SUCCESSFUL COMPLETION OF DLC6030.         */
/**/
             CHGDTAARA  DTAARA(TSTATUS) VALUE('DRSRECOV')
/**/
/************RTVDTAARA**DTAARA(MMOD)*RTNVAR(&MMOD)******************/ /*S01319*/
/*******************************************************************/ /*S01319*/
/**If*FX*present,*set*&FX*to*'Y'************************************/ /*S01319*/
/*******************************************************************/ /*S01319*/
/************IF*********COND(%SST(&MMOD*13*1)**EQ*'Y')*THEN(DO)*****/ /*S01319*/
/**************CHGVAR*****VAR(&FX)*VALUE(Y)*************************/ /*S01319*/
/************ENDDO**************************************************/ /*S01319*/
/*******************************************************************/ /*S01319*/
/*******************************************************************/ /*S01319*/
/**If*MM*present,*set*&MM*to*'Y'************************************/ /*S01319*/
/*******************************************************************/ /*S01319*/
/************IF*********COND(%SST(&MMOD*14*1)**EQ*'Y')*THEN(DO)*****/ /*S01319*/
/**************CHGVAR*****VAR(&MM)*VALUE(Y)*************************/ /*S01319*/
/************ENDDO**************************************************/ /*S01319*/
 
/**/
/* If AB present, set &AB to 'Y' */
/**/
/************IF*********COND(%SST(&MMOD*19*1)**EQ*'Y')*THEN(DO)*****/ /*S01319*/
/******      CALL       PGM(AOMMODR0) PARM(@RTCD @OPTN @FMT) /*S01319* *HY0039*/
/**********  CALL       PGM(AOMMODR0) PARM(@RTCD @OPTN &FMT) /*HY0039* *134471*/
             CALL       PGM(AOMMODR0) PARM(' ' &OPTN &FMT)            /*134471*/
             IF         COND(%SST(&FMT 49 1) *EQ 'Y') THEN(DO)        /*S01319*/
               CHGVAR     VAR(&AB) VALUE(Y)
             ENDDO
/*********************************************************************/
/*                                                                   */
/*     APPLICATION MODULE                                            */
/*     FILE SET UP  -      THIS SECTION INVOKES THE PROGRAM          */
/*                         <MODULE-ID>8010 FOR EACH MODULE THAT IS ON*/
/*                                                                   */
/*********************************************************************/
/**/
/*  Clear batch control areas.                                    */
/**/
             CHGDTAARA  DTAARA(SDSTAT (100 4)) VALUE('0 0 ')
 
/**/
/***If*FX*on,*call*the*Application*program,*FX8010******************/ /*S01319*/
/*  Call the Application program, FX8010 */                           /*S01319*/
/**/
/************IF*********COND(&FX**EQ*'Y')*THEN(DO)******************/ /*S01319*/
             CHGVAR     VAR(&WWCALL) VALUE('CALL PGM(FX8010) PARM('' +
                          '')')
/************SBMJOB*****JOB(FX8010) JOBD(FOJOBD) JOBQ(FOJOBQ) +
/***********************  USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&WWCALL) +
/***********************  INLLIBL(*JOBD) MSGQ(*NONE)               */ /*S01319*/
/************SBMJOB     JOB(FX8010) JOBD(MEODD) JOBQ(MEODQ) +                             /*CPK014*/
/************             USER(*CURRENT) RTGDTA(*JOBD) +                                  /*CPK014*/
/************             RQSDTA(&WWCALL) INLLIBL(*JOBD) +                                /*CPK014*/
/************             MSGQ(*NONE)                                 /*S01319*/          /*CPK014*/
/************SBMJOB     JOB(FX8010) JOBD(MEODD) JOBQ(MEODQ) +                             /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&WWCALL) +                     /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*NONE)                           /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(FX8010) JOBD(MEODD) JOBQ(MEODQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&WWCALL) +
                          INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                          /*CSC023*/
 
             RTVDTAARA  DTAARA(SDSTAT (100 1)) RTNVAR(&WWSUBNA)
             CHGVAR     VAR(&WWSUBN) VALUE(&WWSUBNA)
             CHGVAR     VAR(&WWSUBN) VALUE(&WWSUBN+1)
             CHGVAR     VAR(&WWSUBNA) VALUE(&WWSUBN)
             CHGDTAARA  DTAARA(SDSTAT (100 1)) VALUE(&WWSUBNA)
/************ENDDO**************************************************/ /*S01319*/
/**/
/***If*MM*on,*call*the*Application*program,*MM8010******************/ /*S01319*/
/*  Call the Application program, MM8010 */                           /*S01319*/
/************IF*********COND(&MM**EQ*'Y')*THEN(DO)******************/ /*S01319*/
               CHGVAR     VAR(&WWCALL) VALUE('CALL PGM(MM8010) +
                          PARM('' '')')
/**************SBMJOB*****JOB(MM8010) JOBD(FOJOBD) JOBQ(FOJOBQ) +
/*************************USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&WWCALL) +
/*************************INLLIBL(*JOBD) MSGQ(*NONE)               */ /*S01319*/
/************SBMJOB     JOB(MM8010) JOBD(MEODD) JOBQ(MEODQ) +                             /*CPK014*/
/************             USER(*CURRENT) RTGDTA(*JOBD) +                                  /*CPK014*/
/************             RQSDTA(&WWCALL) INLLIBL(*JOBD) +                                /*CPK014*/
/************             MSGQ(*NONE)                                 /*S01319*/          /*CPK014*/
/************  SBMJOB     JOB(MM8010) JOBD(MEODD) JOBQ(MEODQ) +                           /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&WWCALL) +                     /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*NONE)                           /*CPK014*/ /*CSC023*/
               SBMJOB     JOB(MM8010) JOBD(MEODD) JOBQ(MEODQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&WWCALL) +
                          INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                          /*CSC023*/
 
               RTVDTAARA  DTAARA(SDSTAT (100 1)) RTNVAR(&WWSUBNA)
               CHGVAR     VAR(&WWSUBN) VALUE(&WWSUBNA)
               CHGVAR     VAR(&WWSUBN) VALUE(&WWSUBN+1)
               CHGVAR     VAR(&WWSUBNA) VALUE(&WWSUBN)
               CHGDTAARA  DTAARA(SDSTAT (100 1)) VALUE(&WWSUBNA)
/************ENDDO**************************************************/ /*S01319*/
/**/
/**/
/*  LOOP UNTIL ALL SUBMITTED JOBS ARE COMPLETED  or error found */
/**/
 TAG100:
/**********  DLYJOB     60 */                                                            /*BUG6177*/
             DLYJOB     1                                                                /*BUG6177*/
             RTVDTAARA  DTAARA(SDSTAT (100 4)) RTNVAR(&WWFLGS)
             CHGVAR     &WWSUBN  (%SST(&WWFLGS 1 1))
             CHGVAR     &WWSUBE1 (%SST(&WWFLGS 2 1))
             CHGVAR     &WWSUBE2 (%SST(&WWFLGS 4 1))
             IF        ((&WWSUBN *GT 0 ) *AND +
                         (&WWSUBE1 *NE 'X') *AND +
                          (&WWSUBE2 *NE 'X'))     THEN(GOTO TAG100)
/**/
/*  If AB on, submit the Application program, AB8010 */
/**/
             IF         COND((&AB *EQ 'Y') *AND (&WWSUBE1 *NE +
                          'X') *AND (&WWSUBE2 *NE 'X')) THEN(CALL +
                          PGM(AB8010) PARM(&WWSUBE3))
/**/
/*   If error detected, branch to error processing  */
/**/
             IF         COND((&WWSUBE1 *EQ 'X') *OR (&WWSUBE2 *EQ +
                          'X') *OR (&WWSUBE3 *EQ 'E')) THEN(DO)
                CHGVAR   &WWERR 'Y'
                GOTO     TAG999
             ENDDO
/**/
/*  PROCESSING SUCCESSFULLY COMPLETED - GOTO END OF PROGRAM          */
/**/
             CHGDTAARA  DTAARA(TSTATUS) VALUE('NORMAL  ')
             GOTO       CMDLBL(TAG123)
/**/
 TAG998:     CHGVAR     VAR(&WWERR) VALUE('Y')
/*********************************************************************/
/*                                                                   */
/*     ERROR PROCESSING -  THIS SECTION SENDS THE APPROPRIATE        */
/*                         ERROR MESSAGE TO *EXT FOR THE             */
/*                         FOLLOWING CASES:                          */
/*                                                                   */
/*                         1. DATABASE OR FILE EXCEPTION/ERROR IN    */
/*                            ANY OF THE CALLED PROGRAMS             */
/*                            (U7 & U8 SET)                          */
/*                                                                   */
/*                         2. PROGRAM EXCEPTION/ERROR IN ANY OF      */
/*                            THE CALLED PROGRAMS (U6 SET)           */
/*                                                                   */
/*                         3. ANY OTHER ERROR IN THIS PROGRAM        */
/*                                                                   */
/*     USES:               &WWLDA - SUBSTRING OF *LDA                */
/*                         &WWERR - ERROR IN DLC6030 ONLY 'Y'/'N'    */
/*                                                                   */
/*********************************************************************/
/**/
/*  SWITCHES 7 AND 8 ON                                              */
/**/
 TAG999:     IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                CHGVAR     VAR(&WWLDA) VALUE(%SST(*LDA 134 50))
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&WWLDA) +
                          TOPGMQ(*EXT)
             ENDDO
/**/
/*  SWITCH 6 ON                                                      */
/**/
 
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
                CHGVAR    VAR(&WWLDA) VALUE(%SST(*LDA 171 13))
                SNDPGMMSG MSGID(DBM0004) MSGF(DRSMM) MSGDTA(&WWLDA) +
                          TOPGMQ(*EXT)
             ENDDO
/**/
/* DBASE ERROR REFERENCE POINT 991                                   */
/**/
 
             IF         COND(&WWERR = 'Y') THEN(DO)
                CHGJOB     SWS(XXXXX1XX)
                CHGDTAARA  DTAARA(*LDA (171 7)) VALUE(DLC6030)
                CHGDTAARA  DTAARA(*LDA (181 3)) VALUE('991')
/**********     SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM)  +
                           MSGDTA('DLC6030   '****'991') TOPGMQ(*EXT)*/ /*BG18886*/
                SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM)  +
                           MSGDTA('DLC6030   ' *CAT '991') TOPGMQ(*EXT) /*BG18886*/
             ENDDO
 
/**/
/*  DUMP THE CL PROGRAM                                              */
/**/
             DMPCLPGM
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000)
/**/
TAG123:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
