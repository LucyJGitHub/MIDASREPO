/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas European Reporting - Control Manager')          */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING                               */
/*                                                                  */
/*     ERC0600  - CONTROL MANAGER                                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX024             Date 03Sep99              */
/*                      MHFIX              Date 09Mar99              */
/*                    ER0449             Date 18Jan95               */
/*                    ER_R10             DATE 31OCT94               */
/*                    ERL384             DATE 28DEC93               */
/*                    ER0360             DATE 13OCT93               */
/*                    ERB212             DATE 22SEP93               */
/*                    ER0355             DATE 10AUG93               */
/*                    ERL354             DATE 22JUN93               */
/*                    ER0349             DATE 02JUN93               */
/*                    ER0348             DATE 02JUN93               */
/*                    ER0323             DATE 23FEB93               */
/*                    ER0201             DATE 11JAN93               */
/*                    ER0132             DATE 21DEC92               */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*  ULX024 - Trade Innovation/CSSF Reporting Interface              */
/*  MHFIX  - CALL OF ERC0605 WITH GOOD PARAMETERS                   */
/*  ER0449 - INCLUDE CALL ERC0634 & ERC0635 (FI Loans & Deposits)   */
/*  ER_R10 - EUROPEAN REPORTING - LUXEMBOURG UPGRADE IN R10         */
/*         - REMOVE CL PROCESSING                                   */
/*  ERL384 - REMOVE ERB212 COMPLETLY -ONLY FOR BELGIUM-             */
/*  ER0360 - ERSTAT NOT UPDATED WITH VARIABLE &EXTRACT              */
/*  ERB212 - INCLUDE DL CUSTOMER LIMITS                             */
/*  ER0355 - TO SET UP ERSTAT ACCORDING SDMMODPD AUTOMATICALLY      */
/*  ERL354 - INCLUDE DEPOT MOVEMENTS                                */
/*  ER0349 - WRONG FIELD FOR SYNDICATED LOANS                       */
/*  ER0348 - INCLUDE CUSTOMER POSITIONS                             */
/*  ER0323 - INCLUDE SYNDICATED LOANS EXTRACTS                      */
/*  ER0201 - INCLUDE FO EXTRACTS                                    */
/*  ER0132 - INCORRECT POSITION UPDATE OF ERSTAT                    */
/*                                                                  */
/*********************************************************************/
/**/
PGM
DCL        VAR(&EXTRACT) TYPE(*CHAR) LEN(15)
DCL        VAR(&RESTART)   TYPE(*CHAR) LEN(15)
DCL        VAR(&STATUS)   TYPE(*CHAR) LEN(10)
DCLF       FILE(SDMMODPD) RCDFMT(SDMMODD0)
 
/* BUILT DECISION TABLE  */
 
RCVF       DEV(*FILE) RCDFMT(SDMMODD0)
RTVDTAARA  DTAARA(ERSTAT (1 15)) RTNVAR(&EXTRACT)
RTVDTAARA  DTAARA(ERSTAT (16 15)) RTNVAR(&RESTART)
RTVDTAARA  DTAARA(ERSTAT (31 10)) RTNVAR(&STATUS)
CHGJOB     SWS(00000000)
 
IF (&STATUS *NE 'RESTART') THEN(DO)
     CLRPFM (EREXTRPD)
/* ER0355 START */
/*   CHGDTAARA (ERSTAT (16 40)) VALUE('                         ')           */
/*   IF (%SST(&EXTRACT 1 1)='Y')   THEN(CHGVAR (%SST(&RESTART 1 1)) ('N'))   */
/*   IF (%SST(&EXTRACT 2 1)='Y')   THEN(CHGVAR (%SST(&RESTART 2 1)) ('N'))   */
/*   IF (%SST(&EXTRACT 3 1)='Y')   THEN(CHGVAR (%SST(&RESTART 3 1)) ('N'))   */
/*   IF (%SST(&EXTRACT 4 1)='Y')   THEN(CHGVAR (%SST(&RESTART 4 1)) ('N'))   */
/*   IF (%SST(&EXTRACT 5 1)='Y')   THEN(CHGVAR (%SST(&RESTART 5 1)) ('N'))   */
/*   IF (%SST(&EXTRACT 6 1)='Y')   THEN(CHGVAR (%SST(&RESTART 6 1)) ('N'))   */
/*   IF (%SST(&EXTRACT 7 1)='Y')   THEN(CHGVAR (%SST(&RESTART 7 1)) ('N'))   */
/*   IF (%SST(&EXTRACT 8 1)='Y')   THEN(CHGVAR (%SST(&RESTART 8 1)) ('N'))   */
/*   IF (%SST(&EXTRACT 9 1)='Y')   THEN(CHGVAR (%SST(&RESTART 9 1)) ('N'))   */
/*   IF (%SST(&EXTRACT 10 1)='Y')  THEN(CHGVAR (%SST(&RESTART 10 1)) ('N'))  */
/*   IF (%SST(&EXTRACT 11 1)='Y')  THEN(CHGVAR (%SST(&RESTART 11 1)) ('N'))  */
/*   IF (%SST(&EXTRACT 12 1)='Y')  THEN(CHGVAR (%SST(&RESTART 12 1)) ('N'))  */
/*   IF (%SST(&EXTRACT 13 1)='Y')  THEN(CHGVAR (%SST(&RESTART 13 1)) ('N'))  */
/*   IF (%SST(&EXTRACT 14 1)='Y')  THEN(CHGVAR (%SST(&RESTART 14 1)) ('N'))  */
/*   IF (%SST(&EXTRACT 15 1)='Y')  THEN(CHGVAR (%SST(&RESTART 15 1)) ('N'))  */
     CHGDTAARA (ERSTAT (1 40)) VALUE('                         ')
 
             IF         COND(&BGSDGL = 'Y') THEN(DO)
               CHGVAR     VAR(%SST(&EXTRACT 1 1)) VALUE('Y')
             ENDDO
             ELSE       CMD(DO)
               CHGVAR     VAR(%SST(&EXTRACT 1 1)) VALUE('N')
             ENDDO
               CHGVAR     VAR(%SST(&RESTART 1 1)) VALUE('N')
 
             IF         COND(&BGDLMM = 'Y') THEN(DO)
               CHGVAR     VAR(%SST(&EXTRACT 2 1)) VALUE('Y')
               CHGVAR     VAR(%SST(&EXTRACT 4 1)) VALUE('Y')
/*             CHGVAR     VAR(%SST(&EXTRACT 13 1)) VALUE('Y')ERB212 ERL384*/
             ENDDO
             ELSE       CMD(DO)
               CHGVAR     VAR(%SST(&EXTRACT 2 1)) VALUE('N')
               CHGVAR     VAR(%SST(&EXTRACT 4 1)) VALUE('N')
/*             CHGVAR     VAR(%SST(&EXTRACT 13 1)) VALUE('N')ERB212 ERL384*/
             ENDDO
               CHGVAR     VAR(%SST(&RESTART 2 1)) VALUE('N')
               CHGVAR     VAR(%SST(&RESTART 4 1)) VALUE('N')
/*             CHGVAR     VAR(%SST(&RESTART 13 1)) VALUE('N')ERB212 ERL384*/
 
             IF         COND(&BGDLFX = 'Y') THEN(DO)
               CHGVAR     VAR(%SST(&EXTRACT 3 1)) VALUE('Y')
             ENDDO
             ELSE       CMD(DO)
               CHGVAR     VAR(%SST(&EXTRACT 3 1)) VALUE('N')
             ENDDO
               CHGVAR     VAR(%SST(&RESTART 3 1)) VALUE('N')
 
             IF         COND(&BGCSLN = 'Y') THEN(DO)
               CHGVAR     VAR(%SST(&EXTRACT 5 1)) VALUE('Y')
               CHGVAR     VAR(%SST(&EXTRACT 6 1)) VALUE('Y')
             ENDDO
             ELSE       CMD(DO)
               CHGVAR     VAR(%SST(&EXTRACT 5 1)) VALUE('N')
               CHGVAR     VAR(%SST(&EXTRACT 6 1)) VALUE('N')
             ENDDO
               CHGVAR     VAR(%SST(&RESTART 5 1)) VALUE('N')
               CHGVAR     VAR(%SST(&RESTART 6 1)) VALUE('N')
 
             IF         COND(&BGSECS = 'Y') THEN(DO)
               CHGVAR     VAR(%SST(&EXTRACT 7 1)) VALUE('Y')
               CHGVAR     VAR(%SST(&EXTRACT 11 1)) VALUE('Y')
               CHGVAR     VAR(%SST(&EXTRACT 12 1)) VALUE('Y')
             ENDDO
             ELSE       CMD(DO)
               CHGVAR     VAR(%SST(&EXTRACT 7 1)) VALUE('N')
               CHGVAR     VAR(%SST(&EXTRACT 11 1)) VALUE('N')
               CHGVAR     VAR(%SST(&EXTRACT 12 1)) VALUE('N')
             ENDDO
               CHGVAR     VAR(%SST(&RESTART 7 1)) VALUE('N')
               CHGVAR     VAR(%SST(&RESTART 11 1)) VALUE('N')
               CHGVAR     VAR(%SST(&RESTART 12 1)) VALUE('N')
 
             IF         COND(&BGFUOP = 'Y') THEN(DO)
               CHGVAR     VAR(%SST(&EXTRACT 8 1)) VALUE('Y')
             ENDDO
             ELSE       CMD(DO)
               CHGVAR     VAR(%SST(&EXTRACT 8 1)) VALUE('N')
             ENDDO
               CHGVAR     VAR(%SST(&RESTART 8 1)) VALUE('N')
 
             IF         COND(&BGFIIN = 'Y') THEN(DO)
               CHGVAR     VAR(%SST(&EXTRACT 9 1)) VALUE('Y')
             ENDDO
             ELSE       CMD(DO)
               CHGVAR     VAR(%SST(&EXTRACT 9 1)) VALUE('N')
             ENDDO
               CHGVAR     VAR(%SST(&RESTART 9 1)) VALUE('N')
 
/*********** IF         COND(&BGSYLN = 'Y') THEN(DO)                      ULX024*/
             IF         COND(&BGN3ST = 'Y') THEN(DO)                    /*ULX024*/
               CHGVAR     VAR(%SST(&EXTRACT 10 1)) VALUE('Y')
             ENDDO
             ELSE       CMD(DO)
               CHGVAR     VAR(%SST(&EXTRACT 10 1)) VALUE('N')
             ENDDO
               CHGVAR     VAR(%SST(&RESTART 10 1)) VALUE('N')
 
/* ER0449 START */
             IF         COND(&BGFLND = 'Y') THEN(DO)
               CHGVAR     VAR(%SST(&EXTRACT 14 1)) VALUE('Y')
               CHGVAR     VAR(%SST(&EXTRACT 15 1)) VALUE('Y')
             ENDDO
             ELSE       CMD(DO)
               CHGVAR     VAR(%SST(&EXTRACT 14 1)) VALUE('N')
               CHGVAR     VAR(%SST(&EXTRACT 15 1)) VALUE('N')
             ENDDO
               CHGVAR     VAR(%SST(&RESTART 14 1)) VALUE('N')
               CHGVAR     VAR(%SST(&RESTART 15 1)) VALUE('N')
/* ER0449 END */
 
/* ER0360 START */
     CHGDTAARA (ERSTAT (1 15)) VALUE(&EXTRACT)
/* ER0360 END */
 
/* ER0355 END */
ENDDO
 
/* IF (&BGSTRT = 'Y') THEN(DO)                                         ER_R10 */
IF (&BGLRIN = 'Y') THEN(DO)                                         /* ER_R10 */
 
/* FOR GL ACCOUNT */
     IF ((&BGSDGL='Y')&(%SST(&EXTRACT 1 1)='Y')&(%SST(&RESTART 1 1)='N')) +
     THEN(DO)
          CALL ERC0620
          MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))
          CHGVAR VAR(%SST(&RESTART 1 1)) VALUE('Y')
          IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               CHGVAR VAR(%SST(&RESTART 1 1)) VALUE('N')/**********************/
               CLRPFM (EREXTRPD)                        /* SPECIAL PROCESSING */
               GOTO END                                 /*  FOR GL RECOVERY   */
          ENDDO                                         /**********************/
     ENDDO
 
/* FOR MM DEAL */
     IF ((&BGDLMM='Y')&(%SST(&EXTRACT 2 1)='Y')&(%SST(&RESTART 2 1)='N')) +
     THEN(DO)
          CALL ERC0621
          MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))
          CHGVAR VAR(%SST(&RESTART 2 1)) VALUE('Y')
          IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               CALL ERC0605 PARM('MMD' '   ' '   ' '   ' '   ')
               CHGJOB SWS(00000000)
               CHGVAR VAR(%SST(&RESTART 2 1)) VALUE('N')
          ENDDO
     ENDDO
 
/* FOR FX DEAL */
     IF ((&BGDLFX='Y')&(%SST(&EXTRACT 3 1)='Y')&(%SST(&RESTART 3 1)='N')) +
     THEN(DO)
          CALL ERC0622
          MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))
          CHGVAR VAR(%SST(&RESTART 3 1)) VALUE('Y')
          IF COND(%SWITCH(XXXXXX11)) THEN(DO)
/*MHFIX BEGIN*/
/*             CALL ERC0605 PARM('FXD' '   ' '   ' '   ' '   ')         */
               CALL ERC0605 PARM('FXP' 'FXS' '   ' '   ' '   ')
/*MHFIX END*/
               CHGJOB SWS(00000000)
               CHGVAR VAR(%SST(&RESTART 3 1)) VALUE('N')
          ENDDO
     ENDDO
 
/* FOR NEGOTIABLE ASSET PURCHASE */
     IF ((&BGDLMM='Y')&(%SST(&EXTRACT 4 1)='Y')&(%SST(&RESTART 4 1)='N')) +
     THEN(DO)
          CALL ERC0624
          MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))
          CHGVAR VAR(%SST(&RESTART 4 1)) VALUE('Y')
          IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               CALL ERC0605 PARM('NAP' '   ' '   ' '   ' '   ')
               CHGJOB SWS(00000000)
               CHGVAR VAR(%SST(&RESTART 4 1)) VALUE('N')
          ENDDO
     ENDDO
 
/* FOR LENDING */
     IF ((&BGCSLN='Y')&(%SST(&EXTRACT 5 1)='Y')&(%SST(&RESTART 5 1)='N')) +
     THEN(DO)
          CALL ERC0623
          MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))
          CHGVAR VAR(%SST(&RESTART 5 1)) VALUE('Y')
          IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               CALL ERC0605 PARM('LEN' 'PPU' 'PSO' '   ' '   ')
               CHGJOB SWS(00000000)
               CHGVAR VAR(%SST(&RESTART 5 1)) VALUE('N')
          ENDDO
     ENDDO
 
/* FOR FACILITIES */
     IF ((&BGCSLN='Y')&(%SST(&EXTRACT 6 1)='Y')&(%SST(&RESTART 6 1)='N')) +
     THEN(DO)
          CALL ERC0625
          MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))
          CHGVAR VAR(%SST(&RESTART 6 1)) VALUE('Y')
          IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               CALL ERC0605 PARM('FCL' '   ' '   ' '   ' '   ')
               CHGJOB SWS(00000000)
               CHGVAR VAR(%SST(&RESTART 6 1)) VALUE('N')
          ENDDO
     ENDDO
 
/* FOR SECURITY STRADING */
     IF ((&BGSECS='Y')&(%SST(&EXTRACT 7 1)='Y')&(%SST(&RESTART 7 1)='N')) +
     THEN(DO)
          CALL ERC0627
          MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))
          CHGVAR VAR(%SST(&RESTART 7 1)) VALUE('Y')
          IF COND(%SWITCH(XXXXXX11)) THEN(DO)
/*MHFIX BEGIN*/
/*             CALL ERC0605 PARM('SEC' '   ' '   ' '   ' '   ')    */
               CALL ERC0605 PARM('SEC' 'SEF' '   ' '   ' '   ')
/*MHFIX END*/
               CHGJOB SWS(00000000)
      /*       CHGVAR VAR(%SST(&RESTART 9 1)) VALUE('N')      ER0132 */
               CHGVAR VAR(%SST(&RESTART 7 1)) VALUE('N')   /* ER0132 */
          ENDDO
     ENDDO
 
/* FOR FUTURE & OPTION */
     IF ((&BGFUOP='Y')&(%SST(&EXTRACT 8 1)='Y')&(%SST(&RESTART 8 1)='N')) +
     THEN(DO)
/*        CALL                                                         */
/*        MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))             */
          CALL ERC0628                                      /* ER0201  */
          MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))  /* ER0201  */
          CHGVAR VAR(%SST(&RESTART 8 1)) VALUE('Y')
          IF COND(%SWITCH(XXXXXX11)) THEN(DO)
/*MHFIX BEGIN*/
/*             CALL ERC0605 PARM('FFO' '   ' '   ' '   ' '   ')    */
               CALL ERC0605 PARM('FTR' 'OPT' '   ' '   ' '   ')
/*MHFIX END*/
               CHGJOB SWS(00000000)
               CHGVAR VAR(%SST(&RESTART 8 1)) VALUE('N')
          ENDDO
     ENDDO
 
/* FOR FRA/IRS DEAL */
     IF ((&BGFIIN='Y')&(%SST(&EXTRACT 9 1)='Y')&(%SST(&RESTART 9 1)='N')) +
     THEN(DO)
          CALL ERC0626
          MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))
          CHGVAR VAR(%SST(&RESTART 9 1)) VALUE('Y')
          IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               CALL ERC0605 PARM('FRA' 'IRS' '   ' '   ' '   ')
               CHGJOB SWS(00000000)
               CHGVAR VAR(%SST(&RESTART 9 1)) VALUE('N')
          ENDDO
     ENDDO
                                                                                 /*ULX024*/
 /* For Trade Innovation */                                                      /*ULX024*/
                                                                                 /*ULX024*/
    IF   COND((&BGN3ST = 'Y') & (%SST(&EXTRACT 10 1) +
              = 'Y') & (%SST(&RESTART 10 1) = 'N')) THEN(DO)                     /*ULX024*/
         CALL       PGM(ERC0638)                                                 /*ULX024*/
         MONMSG     MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))                    /*ULX024*/
         CHGVAR     VAR(%SST(&RESTART 10 1)) VALUE('Y')                          /*ULX024*/
         IF   COND(%SWITCH(XXXXXX11)) THEN(DO)                                   /*ULX024*/
              CALL       PGM(ERC0605) PARM('TID' '   ' '   ' '   ' '   ')        /*ULX024*/
              CHGJOB     SWS(00000000)                                           /*ULX024*/
              CHGVAR     VAR(%SST(&RESTART 10 1)) VALUE('N')                     /*ULX024*/
         ENDDO                                                                   /*ULX024*/
    ENDDO                                                                        /*ULX024*/
 
/*** ER0323 BEGIN ***/
/* FOR SYNDICATED LOANS */
/* IF((&BGFIIN='Y')&(%SST(&EXTRACT 10 1)='Y')&(%SST(&RESTART 10 1)='N'))ER0349*/
/*IF*((&BGSYLN='Y')&(%SST(&EXTRACT 10 1)='Y')&(%SST(&RESTART 10 1)='N'))ER_R10*/
/****THEN(DO)                                                           ER_R10*/
/*********CALL ERC0629                                                  ER_R10*/
/*********MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))              ER_R10*/
/*********CHGVAR VAR(%SST(&RESTART 10 1)) VALUE('Y')                    ER_R10*/
/*********IF COND(%SWITCH(XXXXXX11)) THEN(DO)                           ER_R10*/
/*********     CALL ERC0605 PARM('CMT' 'DRW' 'CFL' '   ' '   ')         ER_R10*/
/*********     CHGJOB SWS(00000000)                                     ER_R10*/
/*********     CHGVAR VAR(%SST(&RESTART 10 1)) VALUE('N')               ER_R10*/
/*********ENDDO                                                         ER_R10*/
/****ENDDO                                                              ER_R10*/
/*********                                                              ER_R10*/
/*** ER0323 END ***/
 
/*** ER0348 BEGIN ***/
/* FOR CUSTOMER POSITIONS */
     IF ((&BGSECS='Y')&(%SST(&EXTRACT 11 1)='Y')&(%SST(&RESTART 11 1)='N')) +
     THEN(DO)
          CALL ERC0630
          MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))
          CHGVAR VAR(%SST(&RESTART 11 1)) VALUE('Y')
          IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               CALL ERC0605 PARM('CPO' '   ' '   ' '   ' '   ')
               CHGJOB SWS(00000000)
               CHGVAR VAR(%SST(&RESTART 11 1)) VALUE('N')
          ENDDO
     ENDDO
/*** ER0348 END ***/
 
/*** ERL354 BEGIN ***/
/* FOR DEPOT MOVEMENTS */
     IF ((&BGSECS='Y')&(%SST(&EXTRACT 12 1)='Y')&(%SST(&RESTART 12 1)='N')) +
     THEN(DO)
          CALL ERC0631
          MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))
          CHGVAR VAR(%SST(&RESTART 12 1)) VALUE('Y')
          IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               CALL ERC0605 PARM('DEP' '   ' '   ' '   ' '   ')
               CHGJOB SWS(00000000)
               CHGVAR VAR(%SST(&RESTART 12 1)) VALUE('N')
          ENDDO
     ENDDO
/*** ERL354 END ***/
 
/* ER0449 BEGIN*/
/* FOR FIDUCIARY LOANS AND DEPOSITS */
     IF ((&BGFLND='Y')&(%SST(&EXTRACT 14 1)='Y')&(%SST(&RESTART 14 1)='N')) +
     THEN(DO)
          CALL ERC0634
          MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))
          CHGVAR VAR(%SST(&RESTART 14 1)) VALUE('Y')
          IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               CALL ERC0605 PARM('FID' '   ' '   ' '   ' '   ')
               CHGJOB SWS(00000000)
               CHGVAR VAR(%SST(&RESTART 14 1)) VALUE('N')
          ENDDO
     ENDDO
 
     IF ((&BGFLND='Y')&(%SST(&EXTRACT 15 1)='Y')&(%SST(&RESTART 15 1)='N')) +
     THEN(DO)
          CALL ERC0635
          MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))
          CHGVAR VAR(%SST(&RESTART 15 1)) VALUE('Y')
          IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               CALL ERC0605 PARM('FIL' '   ' '   ' '   ' '   ')
               CHGJOB SWS(00000000)
               CHGVAR VAR(%SST(&RESTART 15 1)) VALUE('N')
          ENDDO
     ENDDO
/* ER0449 END */
 
/*** ERB212 BEGIN  ** O N L Y   F O R   B E L G I U M *** ERL384 ***/
/* FOR DL CUSTOMER LIMITS */
/*** IF ((&BGDLMM='Y')&(%SST(&EXTRACT 13 1)='Y')&(%SST(&RESTART 13 1)='N')) + */
/*** THEN(DO)                                                                 */
/***      CALL ERCB632                                                        */
/***      MONMSG MSGID(CPF0000) EXEC(CHGJOB SWS(00000011))                    */
/***      CHGVAR VAR(%SST(&RESTART 13 1)) VALUE('Y')                          */
/***      IF COND(%SWITCH(XXXXXX11)) THEN(DO)                                 */
/***           CALL ERC0605 PARM('LIM' '   ' '   ' '   ' '   ')               */
/***           CHGJOB SWS(00000000)                                           */
/***           CHGVAR VAR(%SST(&RESTART 13 1)) VALUE('N')                     */
/***      ENDDO                                                               */
/*** ENDDO                                                                    */
/*** ERB212 END ***/
 
/* MAIN CHECK */
END:
     IF COND(&EXTRACT *NE &RESTART) THEN(DO)
          CHGJOB SWS(00000011)
/* ER0355 START */
/*        CHGDTAARA  DTAARA(ERSTAT (31 40)) VALUE('RESTART')  */
          CHGDTAARA  DTAARA(ERSTAT (31 10)) VALUE('RESTART')
/* ER0355 END */
     ENDDO
     ELSE       CMD(DO)
/* ER0355 START */
/*        CHGDTAARA  DTAARA(ERSTAT (31 40)) VALUE('       ')  */
          CHGDTAARA  DTAARA(ERSTAT (31 10)) VALUE('       ')
/* ER0355 END */
     ENDDO
     CHGDTAARA (ERSTAT (16 15)) VALUE(&RESTART)
ENDDO
ENDPGM
