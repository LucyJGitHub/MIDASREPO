/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas PM Extract Details of Flat/Matured Posns')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1130 - PM GENERATE MATURE/FLAT PORTFOLIO HOLDINGS        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 183309             Date 13Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      100075             Date 26Mar96              */
/*                      CPM005             Date 10Jul96              */
/*                      CPM003             DATE 02MAY96              */
/*                      077485             DATE 17DEC95              */
/*                      S01408             DATE 09APR96              */
/*                      CPM004             DATE 07FEB96              */
/*                      094712             DATE 17OCT95              */
/*                      S01486             DATE 18OCT94              */
/*                      058889             DATE 29JUL93              */
/*                      046076  SL         DATE 20OCT92              */
/*                      049421             DATE 18JAN93              */
/*                      049467             DATE 18JAN93              */
/*                      B08253             DATE 10OCT91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       183309 - CPF4101 msg received because correct overrides     */
/*                not in place. Fix is to output error message       */
/*                if Trade/Value Date Position flag on SDPORTPD      */
/*                not set up correctly.                              */
/*              - Monitor for messages after CLOF and DLTOVR.        */
/*              - Add ABNOR processing.                              */
/*       100075 - FOR SEVERAL CASES NOT RECORDS CREATED IN PMMFHLPD  */
/*                FOR AN ACCOUNT CLOSED OR AN MATURITY EVENT         */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*                Recompiled due to changes in PM files.             */
/*       CPM003 - FF/PM Interface upgrade to Release 10              */
/*       077485 - FF/PM INTERFACE : MATURE FLAT POSITIONS NOT        */
/*                EXTRACTED FOR FF TRADES                            */
/*       S01408 - Addition of core hook PMC1130001                   */
/*       CPM004 - Bank Portfolios                                    */
/*       094712 - Replace override to matured loans file with a      */
/*                new parameter in PM1146. (Because PMCLONL2 and     */
/*                PMCLONL4 dont have identical buffer lengths.)      */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       058889 - CORRECTIONS TO SAVING OF CLOSED ACCOUNTS           */
/*       046076 - ADD MONITORING FOR EMPTY FILE ACCNTAB              */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       049467 - RECOMPILED FOR RELEASE 3 PTF 02                    */
/*       B08253 - EXTRACT MATURE/FLAT POSITION TO THE NEW            */
/*                'MATURED' HOLDINGS FILE                            */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/* DECLARE VARIABLES */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)                 *S01486*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                /*S01486*/
             DCL        VAR(&MDID) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)                *S01486*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(200)               /*S01486*/
             DCL        VAR(&DARUN) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01486*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01486*/
             DCL        VAR(&SDPORT) TYPE(*CHAR) LEN(200)             /*S01486*/
             DCL        VAR(&FCTVPS) TYPE(*CHAR) LEN(1)               /*S01486*/
             DCL        VAR(&FCPORS) TYPE(*CHAR) LEN(1)               /*CPM004*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*183309*/
                                                                      /*183309*/
/************DCLF       FILE(SDPORTPD)                                 *S01486*/
/************                                                          *S01486*/
/************RCVF       RCDFMT(SDPORTD0)                               *S01486*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01486*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*S01486*/
             CALL       PGM(AOPORTR0) PARM(&RTCD &OPTN &SDPORT)       /*S01486*/
                                                                      /*S01486*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)                                 /*S01486*/
             ENDDO                                                    /*S01486*/
             ELSE       CMD(CHGVAR VAR(&FCTVPS) VALUE(%SST(&SDPORT +
                          13 1)))                                     /*S01486*/
                                                                      /*CPM004*/
             CHGVAR     VAR(&FCPORS) VALUE(%SST(&SDPORT 112 1))       /*CPM004*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1130 - PM Generate Matured / Flat +
                          Portfolio Holdings') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
 
/* SAVE EVENT CONTROL DATE AS DATE EXTRACT LAST RUN                  */
             RTVDTAARA  DTAARA(PMSTAT (6 5)) RTNVAR(&DARUN)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/**RETRIEVE*DTAARA*MMOD*TO*CHECK*MODULES*PRESENT********************** *S01486*/
/************RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01486*/
/* ACCESS SDMMODPD TO CHECK MODULES PRESENT                          * *S01486*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01486*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*S01486*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &MMOD)         /*S01486*/
                                                                      /*S01486*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)                                 /*S01486*/
             ENDDO                                                    /*S01486*/
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/************OVRDBF     FILE(PMHOLDPP) TOFILE(PMMFHLPP)                *S01486*/
             OVRDBF     FILE(PMHOLDPD) TOFILE(PMMFHLPD)               /*S01486*/
 
             IF         COND((&FCTVPS *NE 'T') *AND (&FCTVPS *NE +
                          'V')) THEN(DO)                              /*183309*/
             SNDPGMMSG  MSGID(PEM0003) MSGF(PMUSRMSG) TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*183309*/
             GOTO       CMDLBL(ABNOR)                                 /*183309*/
             ENDDO                                                    /*183309*/
                                                                      /*183309*/
/* CALL LOMBARD CREDITS EXTRACT */
/************CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 82 1))             *S01486*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 76 1))            /*S01486*/
             IF         COND(&MDID = 'Y') THEN(DO)
/************CALL       PGM(PMC1135) PARM(&P9TVPS)                     *S01486*/
             CALL       PGM(PMC1135) PARM(&FCTVPS)                    /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             ENDDO
 
/**CALL*FIDUCIARY*DETAILS*EXTRACT************************************* *S01486*/
/************OVRDBF     FILE(PMHOLDPP) TOFILE(PMMFHLPP)                *S01486*/
/************CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 81 1))             *S01486*/
/************IF         COND(&MDID = 'Y') THEN(DO)                     *S01486*/
/************OVRDBF     FILE(FIDPLNP2) TOFILE(FIDPLNP3) SHARE(*NO)     *S01486*/
/************CALL       PGM(PM1138) PARM(&P9TVPS 'M')                  *S01486*/
/************                                                          *S01486*/
/**PROCESS*ANY*DATA*BASE*ERROR**************************************** *S01486*/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)               *S01486*/
/************   RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/************   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
/************GOTO       CMDLBL(ABNOR)                                  *S01486*/
/************ENDDO                                                     *S01486*/
/************                                                          *S01486*/
/**CHECK*FOR*FILE*CONTROL*ERRORS*TRAPPED*BY*THE*PROGRAM*************** *S01486*/
/************IF         COND(%SWITCH(XXXXXX01)) THEN(DO)               *S01486*/
/************   RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/************   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
/************GOTO       CMDLBL(ABNOR)                                  *S01486*/
/************ENDDO                                                     *S01486*/
/************ENDDO                                                     *S01486*/
 
/*/COPY WNCPYSRC,PMC1130001                                          */
 
/* CALL SECURITY DETAILS EXTRACT */
/************CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 21 1))             *S01486*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 31 1))            /*S01486*/
/*********** IF ********COND(&MDID = 'Y') THEN(DO)                    /*CPM004*/
             IF         COND(&MDID = 'Y' *AND &FCPORS *NE 'B') +
             THEN(DO)                                                 /*CPM004*/
 
             OVRDBF     FILE(SEEVNT) TOFILE(SECED) SHARE(*NO)
             OVRDBF     FILE(SECET) TOFILE(SECET) SHARE(*NO)
 
/************IF         COND(&P9TVPS *EQ 'T') THEN(DO)                 *S01486*/
             IF         COND(&FCTVPS *EQ 'T') THEN(DO)                /*S01486*/
             OVRDBF     FILE(PMCPOSXX) TOFILE(PMCPMTLL) SHARE(*NO)
             MONMSG     MSGID(CPF0000)                                /*183309*/
             ENDDO
 
/************IF         COND(&P9TVPS *EQ 'V') THEN(DO)                 *S01486*/
             IF         COND(&FCTVPS *EQ 'V') THEN(DO)                /*S01486*/
             OVRDBF     FILE(PMCPOSXX) TOFILE(PMCPMVLL) SHARE(*NO)
             MONMSG     MSGID(CPF0000)                                /*183309*/
             ENDDO
 
             OVRDBF     FILE(PMAPOSLX) TOFILE(PMAPOSLL) SHARE(*NO)
             OVRDBF     FILE(PMAPOSLL) SHARE(*NO)
             OVRDBF     FILE(PMHPOSLL) SHARE(*NO)
             OVRDBF     FILE(PMCPOSL0) SHARE(*NO)
 
/************CALL       PGM(PM1140) PARM('F' &P9TVPS 'M')              *S01486*/
             CALL       PGM(PM1140) PARM('F' &FCTVPS 'M')             /*S01486*/
             DLTOVR     FILE(*ALL)
 
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
                                                                      /*077485*/
/* CALL FUTURES AND OPTIONS DETAILS EXTRACT */                        /*077485*/
             OVRDBF     FILE(PMHOLDPD) TOFILE(PMMFHLPD)               /*077485*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 41 1))            /*077485*/
             IF         COND(&MDID = 'Y') THEN(DO)                    /*077485*/
                                                                      /*077485*/
/* If Bank Portfolios are supported, treat as if FF off               /*CPM003*/
             IF         COND(&FCPORS *NE 'B') THEN(DO)                /*CPM003*/
             CHGDTAARA  DTAARA(FFSTAT (2 1)) VALUE('Y')               /*077485*/
                                                                      /*077485*/
             OPNQRYF    FILE((TRANS2)) QRYSLT('PTFR *NE "    " *AND +
                          RECI *EQ "D" *AND NOCO *EQ 0 *AND MHEX +
                          *EQ " "') KEYFLD((ISTT) (YRNO) (MTHN) +
                          (PCAL) (STRP) (CUSC))                       /*077485*/
                                                                      /*077485*/
             CALL       PGM(PM1142) PARM('F' &FCTVPS 'M')             /*077485*/
             CLOF       OPNID(TRANS2)                                 /*077485*/
                                                                      /*077485*/
             CHGDTAARA  DTAARA(FFSTAT (2 1)) VALUE('N')               /*077485*/
                                                                      /*077485*/
/* PROCESS ANY DATA BASE ERROR */                                     /*077485*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*077485*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*077485*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*077485*/
             GOTO       CMDLBL(ABNOR)                                 /*077485*/
             ENDDO                                                    /*077485*/
                                                                      /*077485*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */            /*077485*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*077485*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*077485*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*077485*/
             GOTO       CMDLBL(ABNOR)                                 /*077485*/
             ENDDO                                                    /*077485*/
             ENDDO                                                    /*CPM003*/
             ENDDO                                                    /*077485*/
 
/* CALL DEALING DETAILS EXTRACT */
/************OVRDBF     FILE(PMHOLDPP) TOFILE(PMMFHLPP)                *S01486*/
             OVRDBF     FILE(PMHOLDPD) TOFILE(PMMFHLPD)               /*S01486*/
/************CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 2 1))              *S01486*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 23 1))            /*S01486*/
             IF         COND(&MDID = 'N') THEN(DO)                    /*S01486*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 48 1))            /*S01486*/
             ENDDO                                                    /*S01486*/
             IF         COND(&MDID = 'Y') THEN(DO)
             OVRDBF     FILE(DEALSH) SHARE(*NO)
/************OVRDBF     FILE(DEALSP2) TOFILE(DEALSP3) SHARE(*NO)       *S01486*/
/************CALL       PGM(PM1144) PARM('F' &P9TVPS 'M')              *S01486*/
             OVRDBF     FILE(PMDEALL2) TOFILE(PMDEALL3) SHARE(*NO)    /*S01486*/
             CALL       PGM(PM1144) PARM('F' &FCTVPS 'M')             /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/* CALL LENDING DETAILS EXTRACT */
/************CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 10 1))             *S01486*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 28 1))            /*S01486*/
             IF         COND(&MDID = 'Y') THEN(DO)
/************OVRDBF     FILE(CLOANP2) TOFILE(CLOANP3) SHARE(*NO)       *S01486*/
/************CALL       PGM(PM1146) PARM('F' &P9TVPS 'M')              *S01486*/
             OVRDBF     FILE(PMCLONL2) TOFILE(PMCLONL3) SHARE(*NO)    /*S01486*/
/************CALL       PGM(PM1146) PARM('F' &FCTVPS 'M')     /*S01486  094712*/
             CALL       PGM(PM1146) PARM('F' &FCTVPS 'M' ' ')         /*094712*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* READ ANY MATURED LOANS FROM PF/MCLONCL */
/************OVRDBF     FILE(CLOANP2) TOFILE(CLOANP4) SHARE(*NO)       *S01486*/
/*******OVRDBF     FILE(PMCLONL2) TOFILE(PMCLONL4) SHARE(*NO) /*S01486  094712*/
             OVRDBF     FILE(PMCLONL4) TOFILE(PMCLONL4) SHARE(*NO)    /*094712*/
/************OVRDBF     FILE(CLOAN) TOFILE(MLOAN) SHARE(*NO)            094712*/
             OVRDBF     FILE(MLOAN) TOFILE(MLOAN) SHARE(*NO)          /*094712*/
/************CALL       PGM(PM1146) PARM('F' &P9TVPS 'M')              *S01486*/
/************CALL       PGM(PM1146) PARM('F' &FCTVPS 'M')     /*S01486  094712*/
             CALL       PGM(PM1146) PARM('F' &FCTVPS 'M' 'M')         /*094712*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/* CALL RETAIL DETAILS EXTRACT */
/************CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 16 1))             *S01486*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 29 1))            /*S01486*/
             IF         COND(&MDID = 'Y') THEN(DO)
/*           CPYF       FROMFILE(ACCNTAB) TOFILE(ACCNTABX) +
                          MBROPT(*REPLACE) INCREL((*IF DACC *EQ +
                          &DARUN) (*AND ATYP *EQ 'R') (*AND PTFR +
                          *NE '    '))                                 058889 */
/* >>> 046076 >>> */
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ACCNTABX))                       058889 *046076*/
/* <<< 046076 <<< */
             OVRDBF     FILE(PMHOLDPD) TOFILE(PMMFHLPD)               /*100075*/
             OVRDBF     FILE(ACCNTP2) TOFILE(ACCNTP3)
/************OVRDBF     FILE(ACCNTP2) TOFILE(ACCNTP3)                  *S01486*/
             OVRDBF     FILE(PMACCNL3) TOFILE(PMACCNL4)               /*S01486*/
/*           CALL       PGM(PM1148) PARM('F' &P9TVPS)           058889*/
/************CALL       PGM(PM1148) PARM('F' &P9TVPS 'M')     *058889* *S01486*/
             CALL       PGM(PM1148) PARM('F' &FCTVPS 'M')             /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
             GOTO       CMDLBL(ENDPGM)                                /*183309*/
/****ABNOR:******ENDPGM                                                *S01486*/
ABNOR:       CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             DLTOVR FILE(*ALL)                                        /*100075*/
                                                                      /*183309*/
             CHGJOB     JOB(*) LOG(4 0 *SECLVL) LOGCLPGM(*YES)        /*183309*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*183309*/
             DSPJOBLOG  OUTPUT(*PRINT)                                /*183309*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*183309*/
             DMPCLPGM                                                 /*183309*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*183309*/
             CHGJOB     SWS(XXXXXX11)                                 /*183309*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*183309*/
                                                                      /*183309*/
ENDPGM:                                                               /*183309*/
             ENDPGM                                                   /*S01486*/
