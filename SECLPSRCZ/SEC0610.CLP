/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Generate Accounting Entries')                */
/*********************************************************************/
/*                                                                   */
/*         Midas     - Securities Trading Module                     */
/*                                                                   */
/*       SEC0610   GENERATE ACCOUNTING ENTRIES                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD049139           Date 16Jun23              */
/*       Prev Amend No. MD021383A          Date 16Jun23              */
/*                      MD020934           Date 11May19              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      258994             Date 16Mar09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CDL045             Date 14Feb06              */
/* Midas Plus 1.2 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX001             Date 18Apr01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE 29APR96              */
/*                      S01502             DATE 08JUL94              */
/*                      E38768             DATE 24APR92              */
/*                      E34692                  DATE  16JAN92        */
/*                      S01117                  DATE  08JAN91        */
/*                      S01189                  DATE  08JAN91        */
/*                      E23408                  DATE  06SEP90        */
/*                      E21136                  DATE  15FEB90        */
/*                      E16870                  DATE  08/03/89       */
/*                      E16663                  DATE  23/01/89       */
/*                      S01179                  DATE  16/09/88       */
/*                      E14224                  DATE  16/09/88       */
/*                                                                   */
/*---------------------------------------------------------------------
/*                                                                   */
/*       MD049139 - Lending Fee are posting 1 day late for           */
/*                  auto settle fee on a calculated facility.        */
/*                - MD061267 - Credit Lines (CLE025) fixes           */
/*       MD021383A - Credit Lines (CLE025) Shadow Posting Correction */
/*                 - MD061267 - Credit Lines (CLE025) fixes          */
/*       MD020934 - COB component LERC135 failed due to CDL045.    */
/*                  Amend length of field &EXTLIB from 8 to 10 to  */
/*                  avoid truncated library name which causes error*/
/*                  - applied for MD-53322                         */
/*       MD046248 - Finastra Rebranding                            */
/*       258994 - Must check job switches before calling MXC0490   */
/*       CDL045 - Copy out Account Keys file to Extract library    */
/*                as specified on the System Value parameter       */
/*                'AccountKeysSavedLib'                            */
/*                Upgrade to Midas Plus 1.2                        */
/*       CMX001 - Meridian Export                                  */
/*       S01408 - Addition of core hook: SEC0610001                */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to      */
/*                change in length of SESTAT, 133 long.            */
/*       E38768 - The program that halts the COB for Missing A/c   */
/*                Keys was not included in the IF/ELSE that checks */
/*                if the halt is required or not.                  */
/*       E34692 - CALL NEW PGM BEFORE SE2450                       */
/*       S01117 - MULTIBRANCHING                                   */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2           */
/*       E23408 - SETON U1 IF RETAIL II OR INTEREST ON ACCOUNTS    */
/*                INSTALLED - CONDITIONS FILE ACNUM IN SE2450.     */
/*                NOTE - RETAIL I NOT SUPPORTED ON AS/400          */
/*       E21136 - PRESENT ACCOUNT KEYS REPORT                      */ /*E21136*/
/*            *** THIS REPORT IS TO HELP WITH INSTALLATION ***     */ /*E21136*/
/*            *** PLEASE COMMENT OUT IF NOT REQUIRED       ***     */ /*E21136*/
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                   */ /*E16870*/
/*       E16663 - PART OF E14224 WITHHELD FROM AS/400 PRODUCT      */ /*E16663*/
/*                UNTIL FILE GEST1 AVAILABLE FROM FIX E14224.      */ /*E16663*/
/*                CODE REINSTATED AS PER S/38 VERSION.             */ /*E16663*/
/*       S01179 -  INCORPORATION                                   */ /*S01179*/
/*       E14224 - WRITE OUT GENERATED ENTRIES TO CORRECT FILE      */ /*E14224*/
/*                FOR ACCRUAL NON-WORKING DAY RUN.                 */ /*E14224*/
/*                                                                 */
/*******************************************************************/
/*           PGM                                                   */ /*E14224*/
/************PGM        PARM(&TYPE)                           *E14224* *S01189*/
             PGM        PARM(&TYPE &CNAM &CSEQ)                       /*S01189*/

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/*           DCLDTAARA  DTAARA(LDA)                                */ /*S01179*/
/*           DCLDTAARA  DTAARA(MMOD)                               */ /*S01179*/
/*           DCLDTAARA  DTAARA(SESTAT)                             */ /*S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
             DCL        VAR(&MMOD)    TYPE(*CHAR)  LEN(256)           /*S01179*/
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)      *S01179E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)*/  /*E16870 S01502*/
             DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(133)           /*S01502*/

/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)                 /*E14224*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5) VALUE('     ')  /*S01189*/
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)               /*CMX001*/
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)               /*CMX001*/
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)               /*CMX001*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CMX001*/
/**********  DCL        VAR(&CMX001) TYPE(*CHAR) LEN(1)  VALUE('N')          */ /*CMX001 MD021383A*/
             DCL        VAR(&CMX001) TYPE(*CHAR) LEN(1)  VALUE('N')                     /*MD049139*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1)  VALUE('N')                     /*MD049139*/
             DCL        VAR(&CDL045) TYPE(*CHAR) LEN(1)  VALUE('N')                       /*CDL045*/
             DCL        VAR(&SEKEY) TYPE(*CHAR) LEN(10)                                   /*CDL045*/
             DCL        VAR(&SEKEY2) TYPE(*CHAR) LEN(10)                                  /*CDL045*/
/**********  DCL        VAR(&EXTLIB) TYPE(*CHAR) LEN(8)                       */ /*CDL045 MD020934*/
             DCL        VAR(&EXTLIB) TYPE(*CHAR) LEN(10)                                /*MD020934*/
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)                                     /*CDL045*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)                                  /*MD021383A*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                                /*MD021383A*/
             DCL        VAR(&CAS006) TYPE(*CHAR) LEN(1) VALUE(N)                       /*MD021383A*/
                                                                                          /*CDL045*/
/* Define parameters used in AOSVALR0 to retrieve system value                            /*CDL045*/
/*/COPY SDCPYSRC,SDSVALDCL                                                                /*CDL045*/
                                                                                          /*CDL045*/
/*/COPY WNCPYSRC,SEC0610002                                          */

/*           RCVDTAARA  DTAARA(MMOD)                                *  *S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/

/*  SETUP AND SEND PGM MESSAGE                                      */

             CHGVAR     VAR(&MEM) VALUE('SEC0610  - Generate +
                          Accounting Entries')

             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/*****************************************************************************/ /*CMX001 MD021383A*/
/****Check*if*Meridian*export*is*installed************************************/ /*CMX001 MD021383A*/
/*****************************************************************************/ /*CMX001 MD021383A*/
/**********  CHGVAR     VAR(&RTCD) VALUE('       ')                          */ /*CMX001 MD021383A*/
/**********  CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                          */ /*CMX001 MD021383A*/
/**********  CHGVAR     VAR(&SAR)  VALUE('CMX001')                           */ /*CMX001 MD021383A*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)         */ /*CMX001 MD021383A*/
/**********                                                                  */ /*CMX001 MD021383A*/
/**********  IF         COND(&RTCD = '       ') +                                      /*MD021383A*/
/**********      THEN(CHGVAR VAR(&CMX001) VALUE('Y'))                        */ /*CMX001 MD021383A*/
/**********                                                                  */ /*CMX001 MD021383A*/
/*                                                  */                                  /*MD049139*/
/* Check if Feature CLE025 is switched ON.          */                                  /*MD049139*/
/*                                                  */                                  /*MD049139*/
             RTVDTAARA  DTAARA(CLE025DTA) RTNVAR(&CLE025)                               /*MD049139*/
             IF         COND(&CLE025 *NE 'Y') THEN(DO)                                  /*MD049139*/
/**/                                                                                    /*MD049139*/
/**  Check if Meridian export is installed                   */                         /*MD049139*/
/**/                                                                                    /*MD049139*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                     /*MD049139*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                     /*MD049139*/
             CHGVAR     VAR(&SAR)  VALUE('CMX001')                                      /*MD049139*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                    /*MD049139*/
                                                                                        /*MD049139*/
             IF         COND(&RTCD = '       ') +
                 THEN(CHGVAR VAR(&CMX001) VALUE('Y'))                                   /*MD049139*/
             ENDDO                                                                      /*MD049139*/

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                             /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                  /*MD049139*/
/* Check if CAS006 is installed */                                                     /*MD021383A*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                    /*MD021383A*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY*')                                   /*MD021383A*/
             CHGVAR     VAR(&SAR) VALUE('CAS006')                                      /*MD021383A*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                   /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAS006) VALUE('Y'))                                     /*MD021383A*/
             ENDDO                                                                      /*MD049139*/

/**/                                                                                      /*CDL045*/
/*   Check if CDL045 is installed   */                                                    /*CDL045*/
/**/                                                                                      /*CDL045*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CDL045*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL045*/
             CHGVAR     VAR(&SAR)  VALUE('CDL045')                                        /*CDL045*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CDL045*/
                                                                                          /*CDL045*/
             IF         COND(&RTCD = '       ') +
                 THEN(CHGVAR VAR(&CDL045) VALUE('Y'))                                     /*CDL045*/
                                                                                          /*CDL045*/
             IF         COND(&CDL045 *EQ 'Y') THEN(DO)                                    /*CDL045*/
                                                                                          /*CDL045*/
      /* Call AOSVALR0 to get system values for 'AccountKeysSavedLib' */                  /*CDL045*/
                                                                                          /*CDL045*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC  +
                          'AccountKeysSavedLib' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CDL045*/
                                                                                          /*CDL045*/
/* If there is an error finding any system value then end abnormally */                   /*CDL045*/
                                                                                          /*CDL045*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CDL045*/
                                                                                          /*CDL045*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                   */ /*CDL045 MD021383A*/
                                                                                          /*CDL045*/
/* Set value of extract library */                                                        /*CDL045*/
                                                                                          /*CDL045*/
             CHGVAR     VAR(&EXTLIB) VALUE(%SST(&SVAL1 1 10))                             /*CDL045*/
             CHGVAR     VAR(&SEKEY) VALUE(&PRFX *CAT 'SEKEYD')                            /*CDL045*/
             CHGVAR     VAR(&SEKEY2) VALUE(&PRFX *CAT 'SEKEYD2')                          /*CDL045*/
                                                                                          /*CDL045*/
         ENDDO                                                                            /*CDL045*/
                                                                                          /*CDL045*/
/*/COPY WNCPYSRC,SEC0610006                                          */
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                  /*MD049139*/
                                                                                       /*MD021383A*/
             CHGVAR     VAR(&DPLIB) VALUE(&PRFX *CAT 'DPLIB')                          /*MD021383A*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)                            /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND((&CSEQ *EQ 4) *OR (&CSEQ *EQ 5)) THEN(DO)                 /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&STAT *EQ 'N') THEN(DO)                                /*MD021383A*/
                                                                                       /*MD021383A*/
/* Delete XGESTxx files if existing */                                                 /*MD021383A*/
                                                                                       /*MD021383A*/
                   DLTF       FILE(&DPLIB/XGESTHH)                                     /*MD021383A*/
                   MONMSG     MSGID(CPF2105)                                           /*MD021383A*/
                   DLTF       FILE(&DPLIB/XGESTPD)                                     /*MD021383A*/
                   MONMSG     MSGID(CPF2105)                                           /*MD021383A*/
                   DLTF       FILE(&DPLIB/XGESTZZ)                                     /*MD021383A*/
                   MONMSG     MSGID(CPF2105)                                           /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&TYPE *EQ '1') THEN(DO)                             /*MD021383A*/
                                                                                       /*MD021383A*/
/* Backup GESTxx files */                                                              /*MD021383A*/
                                                                                       /*MD021383A*/
                      CPYF       FROMFILE(GESTHH) +
                                   TOFILE(&DPLIB/XGESTHH) CRTFILE(*YES)                /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                      CPYF       FROMFILE(GESTPD) +
                                   TOFILE(&DPLIB/XGESTPD) CRTFILE(*YES)                /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                      CPYF       FROMFILE(GESTZZ) +
                                   TOFILE(&DPLIB/XGESTZZ) CRTFILE(*YES)                /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&TYPE *EQ '5') THEN(DO)                             /*MD021383A*/
                                                                                       /*MD021383A*/
/* Backup GEST1xx files */                                                             /*MD021383A*/
                                                                                       /*MD021383A*/
                      CPYF       FROMFILE(GEST1HH) +
                                   TOFILE(&DPLIB/XGESTHH) +
                                   CRTFILE(*YES)                                       /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                      CPYF       FROMFILE(GEST1PD) +
                                   TOFILE(&DPLIB/XGEST1PD) +
                                   CRTFILE(*YES)                                       /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                      CPYF       FROMFILE(GEST1ZZ) +
                                   TOFILE(&DPLIB/XGEST1ZZ) +
                                   CRTFILE(*YES)                                       /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&STAT *EQ 'Y') THEN(DO)                                /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&TYPE *EQ '1') THEN(DO)                             /*MD021383A*/
                                                                                       /*MD021383A*/
/* Restore GESTxx files */                                                             /*MD021383A*/
                                                                                       /*MD021383A*/
                      CPYF       FROMFILE(&DPLIB/XGESTHH) +
                                   TOFILE(GESTHH) MBROPT(*REPLACE)                     /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GESTHH))                           /*MD021383A*/
                      CPYF       FROMFILE(&DPLIB/XGESTPD) +
                                   TOFILE(GESTPD) MBROPT(*REPLACE)                     /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GESTPD))                           /*MD021383A*/
                      CPYF       FROMFILE(&DPLIB/XGESTZZ) +
                                   TOFILE(GESTZZ) MBROPT(*REPLACE)                     /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GESTZZ))                           /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&TYPE *EQ '5') THEN(DO)                             /*MD021383A*/
                                                                                       /*MD021383A*/
/* Restore GEST1xx files */                                                            /*MD021383A*/
                                                                                       /*MD021383A*/
                      CPYF       FROMFILE(&DPLIB/XGESTHH) +
                                   TOFILE(GEST1HH) MBROPT(*REPLACE)                    /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GEST1HH))                          /*MD021383A*/
                      CPYF       FROMFILE(&DPLIB/XGESTPD) +
                                   TOFILE(GEST1PD) MBROPT(*REPLACE)                    /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GEST1PD))                          /*MD021383A*/
                      CPYF       FROMFILE(&DPLIB/XGESTZZ) +
                                   TOFILE(GEST1ZZ) MBROPT(*REPLACE)                    /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GEST1ZZ))                          /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
             CHGVAR     VAR(&STAT) VALUE('Y')                                          /*MD021383A*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                            /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                      /*MD049139*/
/*     RESET SWITCHES                                               */

/************IF*********COND(%SST(&MMOD 3 1) = 'Y') THEN(CHGJOB +  E23408*/
/*************************SWS(10000000))                           E23408*/

/*  SET ON U1 IF RETAIL II OR INTEREST ON ACCOUNTS INSTALLED      *E23408*/

             IF         COND((%SST(&MMOD 16 1) = 'Y')     +
                          *OR (%SST(&MMOD 23 1) = 'Y'))   +
                          THEN(CHGJOB SWS(10000000))             /*E23408*/
             ELSE (CHGJOB     SWS(00000000))

/*   CLEAR O/P FILES */

/**********  IF         COND((&CSEQ *EQ 1) *OR (&CSEQ *EQ 3)) THEN(DO)    */  /*MD021383A MD049139*/
             IF         COND(((&CLE025 *EQ 'Y') *AND +
                              ((&CSEQ *EQ 1) *OR (&CSEQ *EQ 3))) *OR +
                             (&CLE025 *NE 'Y')) THEN(DO)                                /*MD049139*/
             IF         COND(&TYPE *EQ '1') THEN(DO)                  /*E16663*/
             CLRPFM     FILE(GESTHH)
             CLRPFM     FILE(GESTPD)
             CLRPFM     FILE(GESTZZ)
             ENDDO                                                    /*E16663*/
             ELSE       CMD(DO)                                       /*E16663*/
             CLRPFM     FILE(GEST1HH)                                 /*E16663*/
             CLRPFM     FILE(GEST1PD)                                 /*E16663*/
             CLRPFM     FILE(GEST1ZZ)                                 /*E16663*/
             OVRDBF     FILE(GEST) TOFILE(GEST1)                      /*E16663*/
             ENDDO                                                    /*E16663*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND((&CSEQ *EQ 4) *OR (&CSEQ *EQ 5)) THEN(DO)                 /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&TYPE *EQ '1') THEN(DO)                                /*MD021383A*/
                   CLRPFM     FILE(GEST3HH)                                            /*MD021383A*/
                   CLRPFM     FILE(GEST3PD)                                            /*MD021383A*/
                   CLRPFM     FILE(GEST3ZZ)                                            /*MD021383A*/
                   OVRDBF     FILE(GEST) TOFILE(GEST3)                                 /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&TYPE *EQ '5') THEN(DO)                                /*MD021383A*/
                   CLRPFM     FILE(GEST4HH)                                            /*MD021383A*/
                   CLRPFM     FILE(GEST4PD)                                            /*MD021383A*/
                   CLRPFM     FILE(GEST4ZZ)                                            /*MD021383A*/
                   OVRDBF     FILE(GEST) TOFILE(GEST4)                                 /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/

/*   CALL SE2445 TO SUPPRESS BOOK CODES/INVESTMENT TYPES ON SEKEY  */ /*E34692*/
/*              IF NECESSARY                                       */ /*E34692*/
             CALL       PGM(SE2445)                                   /*E34692*/

/*/COPY WNCPYSRC,SEC0610003                                          */
/*   CALL PROGRAM                        */

/************CALL       PGM(SE2450)                                  * *S01117*/
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                  /*MD049139*/
                                                                                       /*MD021383A*/
             IF         COND(&CAS006 *EQ 'N') THEN(DO)                                 /*MD021383A*/
                IF         COND((&CSEQ *EQ 4) *OR (&CSEQ *EQ 5)) THEN(DO)              /*MD021383A*/
                  CALL       PGM(SE000150) PARM('SEKEYA' 'Write')                      /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                      /*MD049139*/
             CALL       PGM(SE2450) PARM(&RSEQ)                       /*S01117*/
/*/COPY WNCPYSRC,SEC0610004                                          */

/**********  IF         COND(&TYPE *EQ '5') THEN(DLTOVR FILE(GEST))          */ /*E16663 MD021383A*/
             IF         COND((&CLE025 *NE 'Y') *AND +
                             (&TYPE *EQ '5')) +
                        THEN(DLTOVR FILE(GEST))                                         /*MD049139*/
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                  /*MD049139*/
             IF         COND((&CSEQ *EQ 3) *OR (&CSEQ *EQ 4) *OR +
                          (&CSEQ *EQ 5)) THEN(DLTOVR FILE(GEST))                       /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND((&CSEQ *EQ 1) *OR (&CSEQ *EQ 3)) THEN(DO)                 /*MD021383A*/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                            /*MD021383A*/
                   CLRPFM     FILE(&DPLIB/SEKEY1D)                                     /*MD021383A*/
                   CPYF       FROMFILE(SEKEYD) TOFILE(SEKEY1D) +
                                FROMMBR(*ALL) TOMBR(*FROMMBR) +
                                MBROPT(*REPLACE)                                       /*MD021383A*/
                   MONMSG     MSGID(CPF2817 CPF2869)                                   /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
             ENDDO                                                                      /*MD049139*/
                                                                                       /*MD021383A*/
             IF         COND((&CSEQ *EQ 4) *OR (&CSEQ *EQ 5)) THEN(DO)                 /*MD021383A*/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                            /*MD021383A*/
                   IF         COND(&TYPE *EQ '1') THEN(DO)                             /*MD021383A*/
                                                                                       /*MD021383A*/
                      CPYF       FROMFILE(GEST3PD) TOFILE(GESTPD) +
                                   MBROPT(*ADD)                                        /*MD021383A*/
                      CALL       PGM(SE000150) PARM('GEST3ZZ' 'Update')                /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&TYPE *EQ '5') THEN(DO)                             /*MD021383A*/
                      CPYF       FROMFILE(GEST4PD) TOFILE(GEST1PD) +
                                   MBROPT(*ADD)                                        /*MD021383A*/
                      CALL       PGM(SE000150) PARM('GEST4ZZ' 'Update')                /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                   CPYF       FROMFILE(SEKEY1D) TOFILE(&DPLIB/SEKEYD) +
                                FROMMBR(*ALL) TOMBR(*FROMMBR) +
                                MBROPT(*ADD)                                           /*MD021383A*/
                   MONMSG     MSGID(CPC2957 CPF2817 CPF2869)                           /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
                                                                      /*CMX001*/
/**********  IF         COND(&CMX001 = 'Y') THEN(DO)                         */ /*CMX001 MD021383A*/
/**********  IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                     */ /*258994 MD021383A*/
/**********  CALL       PGM(MXC0490) PARM('SEC0610 ' &TYPE)                  */ /*CMX001 MD021383A*/
/**********  ENDDO                                                           */ /*258994 MD021383A*/
/**********  ENDDO                                                           */ /*CMX001 MD021383A*/
             IF         COND(&CLE025 *NE 'Y') THEN(DO)                                  /*MD049139*/
             IF         COND(&CMX001 = 'Y') THEN(DO)                                    /*MD049139*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                /*MD049139*/
             CALL       PGM(MXC0490) PARM('SEC0610 ' &TYPE)                             /*MD049139*/
             ENDDO                                                                      /*MD049139*/
             ENDDO                                                                      /*MD049139*/
             ENDDO                                                                      /*MD049139*/
                                                                      /*CMX001*/
/**/
/*  ABNORMAL TERMINATION MESSAGE - DATABASE ERROR                   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*           RCVDTAARA  DTAARA(LDA)                                */ /*S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/************CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))           * *S01117*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('SEC0610 - Database Error') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(SNDPGMMSG +
                          MSG('SEC0610 - File Controls out of +
                          Balance') TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ))
/**/
/*  IF A/C KEYS MISSING CHECK D/SESTAT WHETHER TO CONTINUE OR NOT  */
/*****HALT*MESSAGE*&*CONTROL*IS*HANDLED*BY*EODRUN****************      *S01189*/
/*  CALL CB0175 TO HALT COB RUN                                        *S01189*/

             IF         COND(%SWITCH(XXX1XXX0)) THEN(DO)
/*              RCVDTAARA  DTAARA(SESTAT)                           *  *S01179*/
                RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)             /*S01179*/
             IF         COND(%SST(&SESTAT 5 1) *EQ 'Y') +
                          THEN(SNDPGMMSG MSG('SEC0610 - Securities +
                          Trading A/C Keys Missing - processing +
                          continued') TOMSGQ(MRUNQ))
/*********** ELSE       CMD(SNDPGMMSG MSG('SEC0610 - Securities +  *** *E38768*/
/***********              Trading A/C Keys Missing - processing +  *** *E38768*/
/***********              halted') TOMSGQ(MOPERQ MRUNQ))           *** *E38768*/
/**/                                                                  /*E38768*/
             ELSE DO                                                  /*E38768*/
                  SNDPGMMSG MSG('SEC0610 - Securities Trading +
                     A/c Keys Missing - processing halted') +
                     TOMSGQ(MOPERQ MRUNQ)                             /*E38768*/
/**/                                                                  /*S01189*/
                        CALL       PGM(CB0175) PARM(&CNAM &CSEQ)      /*S01189*/
/*/COPY WNCPYSRC,SEC0610007                                          */
                  ENDDO                                               /*E38768*/
/**/
             ENDDO
                                                                                          /*CDL045*/
/* CDL045 - Copy out Account Keys file(s) to Extract library   */                         /*CDL045*/
                                                                                          /*CDL045*/
             IF         COND(&CDL045 *EQ 'Y') THEN(DO)                                    /*CDL045*/
                                                                                          /*CDL045*/
             IF         COND(&TYPE = '1') THEN(DO)                                        /*CDL045*/
/**********  IF         COND(&CSEQ *EQ 1) THEN(DO)                        */  /*MD021383A MD049139*/
             IF         COND((&CLE025 *NE 'Y') *OR +
                             ((&CLE025 *EQ 'Y') *AND (&CSEQ *EQ 1))) +
                        THEN(DO)                                                        /*MD049139*/
                                                                                          /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(ACCRUAL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(ACCRUAL)                                 /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /* To member is empty*/          /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(BKMATUR) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(BKMATUR)                                 /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /*To member is empty*/           /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
                                                                                          /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(BKPOSN) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(BKPOSN)                                  /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /*To member is empty*/           /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(BKPOSNR) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(BKPOSNR)                                 /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /*To member is empty*/           /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(CONTLIAB) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(CONTLIAB)                                /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /*To member is empty*/           /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(CPOSN1) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(CPOSN1)                                  /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /*To member is empty*/           /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(CPOSN2) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(CPOSN2)                                  /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /*To member is empty*/           /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(DEPOTMVT) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(DEPOTMVT)                                /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /*To member is empty*/           /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(DPOSN1) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(DPOSN1)                                  /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /*To member is empty*/           /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(DPOSN2) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(DPOSN2)                                  /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /*To member is empty*/           /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(MMREVAL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(MMREVAL)                                 /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /*To member is empty*/           /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(PSETTLE) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(PSETTLE)                                 /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /*To member is empty*/           /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(TRADE) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(TRADE)                                   /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /*To member is empty*/           /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY) +
                          FROMMBR(TSETTLE) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(DO)  /* From member is empty*/        /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY) MBR(TSETTLE)                                 /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)   /*To member is empty*/           /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
                                                                                          /*CDL045*/
   /* Clear out the ANWD files */                                                         /*CDL045*/
                                                                                          /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(ACCRUAL)                                /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(BKMATUR)                                /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(BKPOSN)                                 /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(BKPOSNR)                                /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(CONTLIAB)                               /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(CPOSN1)                                 /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(CPOSN2)                                 /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(DEPOTMVT)                               /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(DPOSN1)                                 /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(DPOSN2)                                 /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(MMREVAL)                                /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(PSETTLE)                                /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(TRADE)                                  /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(TSETTLE)                                /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND(&CSEQ *EQ 4) THEN(DO)                                     /*MD021383A*/
                CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/SEKEY) +
                             FROMMBR(ACCRUAL) MBROPT(*ADD)                             /*MD021383A*/
                MONMSG     MSGID(CPC2957 CPF2817 CPF2869)                              /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
 /**/                                                                                     /*CDL045*/
         ENDDO                                                                            /*CDL045*/
 /**/                                                                                     /*CDL045*/
 /* ACCRUAL NON WORKING DAY   */                                                          /*CDL045*/
 /**/                                                                                     /*CDL045*/
             IF         COND(&TYPE = '5') THEN(DO)                                        /*CDL045*/
/**********  IF         COND(&CSEQ *EQ 3) THEN(DO)                        */  /*MD021383A MD049139*/
             IF         COND((&CLE025 *NE 'Y') *OR +
                             ((&CLE025 *EQ 'Y') *AND (&CSEQ *EQ 3))) +
                        THEN(DO)                                                        /*MD049139*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(ACCRUAL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                          FILE(&EXTLIB/&SEKEY2) MBR(ACCRUAL))                             /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(BKMATUR) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                          FILE(&EXTLIB/&SEKEY2) MBR(BKMATUR))                             /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(BKPOSN) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                        FILE(&EXTLIB/&SEKEY2) MBR(BKPOSN))                                /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(BKPOSNR) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                        FILE(&EXTLIB/&SEKEY2) MBR(BKPOSNR))                               /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(CONTLIAB) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                        FILE(&EXTLIB/&SEKEY2) MBR(CONTLIAB))                              /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(CPOSN1) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                       FILE(&EXTLIB/&SEKEY2) MBR(CPOSN1))                                 /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(CPOSN2) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                        FILE(&EXTLIB/&SEKEY2) MBR(CPOSN2))                                /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(DEPOTMVT) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                        FILE(&EXTLIB/&SEKEY2) MBR(DEPOTMVT))                              /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(DPOSN1) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                        FILE(&EXTLIB/&SEKEY2) MBR(DPOSN1))                                /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(DPOSN2) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                        FILE(&EXTLIB/&SEKEY2) MBR(DPOSN2))                                /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(MMREVAL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                        FILE(&EXTLIB/&SEKEY2) MBR(MMREVAL))                               /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(PSETTLE) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                        FILE(&EXTLIB/&SEKEY2) MBR(PSETTLE))                               /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(TRADE) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                        FILE(&EXTLIB/&SEKEY2) MBR(TRADE))                                 /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                          FROMMBR(TSETTLE) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
                                                                                          /*CDL045*/
             MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM  +
                        FILE(&EXTLIB/&SEKEY2) MBR(TSETTLE))                               /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)    /* To member is empty */        /*CDL045*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND(&CSEQ *EQ 5) THEN(DO)                                     /*MD021383A*/
                CPYF       FROMFILE(SEKEYD) TOFILE(&EXTLIB/&SEKEY2) +
                             FROMMBR(ACCRUAL) MBROPT(*ADD)                             /*MD021383A*/
                MONMSG     MSGID(CPC2957 CPF2817 CPF2869)                              /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
 /**/                                                                                     /*CDL045*/
             ENDDO                                                                        /*CDL045*/
 /**/                                                                                     /*CDL045*/
             ELSE       CMD(DO)                           /* daily accrual */             /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(ACCRUAL)                                /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(BKMATUR)                                /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(BKPOSN)                                 /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(BKPOSNR)                                /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(CONTLIAB)                               /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(CPOSN1)                                 /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(CPOSN2)                                 /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(DEPOTMVT)                               /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(DPOSN1)                                 /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(DPOSN2)                                 /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(MMREVAL)                                /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
 /**/                                                                                     /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(PSETTLE)                                /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(TRADE)                                  /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&SEKEY2) MBR(TSETTLE)                                /*CDL045*/
             MONMSG     MSGID(CPF3142 CPF2870 CPF2817 CPF2869)                            /*CDL045*/
             ENDDO                                                                        /*CDL045*/
                                                                                          /*CDL045*/
         ENDDO                                                                            /*CDL045*/
                                                                                          /*CDL045*/
/**/                                                                  /*E21136*/
/*    PRESENT A/C KEYS REPORT                                           E21136*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*E21136*/
             OVRDBF     FILE(SEKEY) TOFILE(SEKEYD) MBR(*ALL)          /*E21136*/
/************CALL SE2455                                      *E21136* *S01117*/
             CALL       PGM(SE2455) PARM(&RSEQ)                       /*S01117*/
             DLTOVR SEKEY                                             /*E21136*/
/**/                                                                  /*E21136*/
                                                                                          /*CDL045*/
  ABNOR:                                                                                  /*CDL045*/
                                                                                          /*CDL045*/
/*  ABNORMAL TERMINATION MESSAGE - DATABASE ERROR                       E21136*/
/**/                                                                  /*E21136*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*E21136*/
/*           RCVDTAARA  DTAARA(LDA)                                */ /*E21136*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*E21136*/
/************CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))     E21136* *S01117*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*E21136*/
             SNDPGMMSG  MSG('SEC0610 - Database Error') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*E21136*/
             ENDDO                                                    /*E21136*/
             ENDDO                                                    /*E21136*/
/**/
/*                                                         S01408    */
/*/COPY WNCPYSRC,SEC0610001                                          */
/*                                                         S01408    */
                                                                                       /*MD021383A*/
/* If no error occured in the program, update the restart flag */                      /*MD021383A*/
/* delete backup files */                                                              /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                               /*MD021383A*/
                CHGVAR     VAR(&STAT) VALUE('N')                                       /*MD021383A*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                         /*MD021383A*/
                                                                                       /*MD021383A*/
                DLTF       FILE(&DPLIB/XGESTHH)                                        /*MD021383A*/
                MONMSG     MSGID(CPF2105)                                              /*MD021383A*/
                DLTF       FILE(&DPLIB/XGESTPD)                                        /*MD021383A*/
                MONMSG     MSGID(CPF2105)                                              /*MD021383A*/
                DLTF       FILE(&DPLIB/XGESTZZ)                                        /*MD021383A*/
                MONMSG     MSGID(CPF2105)                                              /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,SEC0610005                                          */
             ENDPGM
