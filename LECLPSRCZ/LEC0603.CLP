/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Daily file maintenance - 1')                 */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                       */
/*                                                                  */
/*     LEC0603 - DAILY FILE MAINTENANCE  -  1                       */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/*                      251331             Date 22Nov07              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CAS016             Date 28Feb06              */
/*                      CAS009             Date 04May04              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*                      185526             Date 17Oct01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      180044             Date 17Jul00              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      134725             Date 14Jun99              */
/*                      127731             Date 04Dec97              */
/*                      CLE003             Date 08Jan97             */
/*                      S01408             Date 26Apr96             */
/*                      S01427            DATE  13JUL93             */
/*                      S01194            DATE  08FEB90             */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       251331 - Ensure CLOAN* files are correctly rolled back if   */
/*                component fails.                                   */
/*       CAS016 - IAS18 EIR Recalculation (Fee Amortisation Over     */
/*                Whole Period)                                      */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       185526 - Part Sold Amount not rolled over. Also call LE0389 */
/*                when CEU020 is switched on, for 'EMU' rollovers.   */
/*       180044 - Clear output physical file REVPDDP.                */
/*       134725 - Call LE0389 before LE0390 if CLE004 is installed   */
/*       127731 - Reactivate Matured Loans                           */
/*       CLE003 - LENDING ENHANCEMENTS                              */
/*       S01408 - Addition of core hooks: LEC0603001                 */
/*                Addition of core hooks: LEC0603002                 */
/*                Addition of core hooks: LEC0603003                 */
/*                Addition of core hooks: LEC0603004                 */
/*       S01427 - R10 CHIPS INCORPORATION                           */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/************PGM                                                ****/ /*CLE003*/
             PGM        PARM(&CONAM &COSEQ)                           /*CLE003*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('CUSTOMER LENDING FILE UPDATE +
                        PHASE ONE ')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01427*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01427*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01427*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CLE003*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CLE003*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CLE003*/
             DCL        VAR(&CLE003) TYPE(*CHAR) LEN(1)               /*CLE003*/
             DCL        VAR(&CONAM) TYPE(*CHAR) LEN(10)               /*CLE003*/
             DCL        VAR(&COSEQ) TYPE(*DEC) LEN(5 0)               /*CLE003*/
             DCL        VAR(&STUS) TYPE(*CHAR) LEN(1)                 /*CLE003*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*127731*/
             DCL        VAR(&CLE005) TYPE(*CHAR) LEN(1)               /*127731*/
             DCL        VAR(&CLE004) TYPE(*CHAR) LEN(1)               /*134725*/
             DCL        VAR(&CEU020) TYPE(*CHAR) LEN(1)               /*185526*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CAS009*/
             DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1)                                   /*CAS009*/
             DCL        VAR(&CAS016) TYPE(*CHAR) LEN(1)                                   /*CAS016*/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)                                   /*CAS016*/
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)                                     /*CAS016*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                                 /*CAS016*/
                                                                                          /*CAS009*/
/*/COPY WNCPYSRC,LEC0603005                                          */
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/*                                                   */               /*CLE003*/
/*   Access Switchable SAR details                   */               /*CLE003*/
/*                                                   */               /*CLE003*/
/*/COPY WNCPYSRC,LEC0603006                                          */
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CLE003*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE003*/
             CHGVAR     VAR(&SARD) VALUE('CLE003')                    /*CLE003*/
/*                                                   */               /*CLE003*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)         /*CLE003*/
/*                                                        */          /*CLE003*/
/*       Feature found if return code is blank            */          /*CLE003*/
/*                                                        */          /*CLE003*/
             IF COND((&RTCD) *EQ '       ') THEN(DO)                  /*CLE003*/
             CHGVAR     VAR(&CLE003) VALUE('Y')                       /*CLE003*/
             ENDDO                                                    /*CLE003*/
/**/                                                                                      /*CAS016*/
/* Check if CAS016 is enabled. */                                                         /*CAS016*/
/**/                                                                                      /*CAS016*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CAS016*/
             CHGVAR     VAR(&SARD) VALUE('CAS016')                                        /*CAS016*/
                                                                                          /*CAS016*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                     /*CAS016*/
                                                                                          /*CAS016*/
             CHGVAR     VAR(&CAS016) VALUE('N')                                           /*CAS016*/
             IF         COND(&RTCD *EQ '       ') +
                          THEN(CHGVAR VAR(&CAS016) VALUE('Y'))                            /*CAS016*/
                                                                                          /*CAS016*/
                                                                                          /*CAS016*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                                    /*CAS016*/
                                                                                          /*CAS016*/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))                                /*CAS016*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')                             /*CAS016*/
                                                                                          /*CAS016*/
/**/                                                                                      /*CAS009*/
/* Check if CAS009 is enabled. */                                                         /*CAS009*/
/**/                                                                                      /*CAS009*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CAS009*/
             CHGVAR     VAR(&SARD) VALUE('CAS009')                                        /*CAS009*/
                                                                                          /*CAS009*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                     /*CAS009*/
                                                                                          /*CAS009*/
             CHGVAR     VAR(&CAS009) VALUE('N')                                           /*CAS009*/
             IF         COND(&RTCD *EQ '       ') +
                          THEN(CHGVAR VAR(&CAS009) VALUE('Y'))                            /*CAS009*/
/**/                                                                                      /*CAS009*/
             CHGVAR     VAR(&STUS) VALUE(' ')                                             /*CAS009*/
             CALL       PGM(CB0160) PARM(&CONAM &COSEQ &STUS)                             /*CAS009*/
/**/                                                                                      /*CAS009*/
             IF COND((&STUS) *EQ 'Y') THEN(DO)                                            /*CAS009*/
/**/                                                                                      /*CAS009*/
             IF COND((&CLE003) *EQ 'Y') THEN(DO)                      /*CLE003*/
/*                                                   */               /*CLE003*/
/**********  CALL       PGM(CB0160) PARM(&CONAM &COSEQ &STUS)       **/            /*CLE003 CAS009*/
/**********  IF COND((&STUS) *EQ 'Y') THEN(DO)                      **/            /*CLE003 CAS009*/
/**/                                                                                      /*251331*/
/* Putback original CLOAN* files if component failed */                                   /*251331*/
/**/                                                                                      /*251331*/
             CPYF       FROMFILE(NCLONHH) TOFILE(CLOANHH) +
                          MBROPT(*REPLACE)                                                /*251331*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CLOANHH))                                                  /*251331*/
             CPYF       FROMFILE(NCLONCL) TOFILE(CLOANCL) +
                          MBROPT(*REPLACE)                                                /*251331*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CLOANCL))                                                  /*251331*/
             CPYF       FROMFILE(NCLONCK) TOFILE(CLOANCK) +
                          MBROPT(*REPLACE)                                                /*251331*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CLOANCK))                                                  /*251331*/
             CPYF       FROMFILE(NCLONZ1) TOFILE(CLOANZ1) +
                          MBROPT(*REPLACE)                                                /*251331*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CLOANZ1))                                                  /*251331*/
/**/                                                                                      /*251331*/
             CPYF       FROMFILE(HIUPDHH) TOFILE(HISTSHH) +
                          MBROPT(*REPLACE)                            /*CLE003*/
             CPYF       FROMFILE(HIUPDHM) TOFILE(HISTSHM) +
                          MBROPT(*REPLACE)                            /*CLE003*/
             CPYF       FROMFILE(HIUPDHN) TOFILE(HISTSHN) +
                          MBROPT(*REPLACE)                            /*CLE003*/
             CPYF       FROMFILE(HIUPDHP) TOFILE(HISTSHP) +
                          MBROPT(*REPLACE)                            /*CLE003*/
             CPYF       FROMFILE(HIUPDHQ) TOFILE(HISTSHQ) +
                          MBROPT(*REPLACE)                            /*CLE003*/
             CPYF       FROMFILE(HIUPDZX) TOFILE(HISTSZX) +
                          MBROPT(*REPLACE)                            /*CLE003*/
             ENDDO                                                    /*CLE003*/
/**/                                                                                      /*CAS009*/
             IF COND((&CAS009) *EQ 'Y') THEN(DO)                                          /*CAS009*/
               CPYF       FROMFILE(XLEEIRDPD) TOFILE(LEEIRDPD) +
                          MBROPT(*REPLACE)                                                /*CAS009*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(LEEIRDPD))                                               /*CAS009*/
             ENDDO                                                                        /*CAS009*/
                                                                                          /*CAS016*/
             IF COND((&CAS016) *EQ 'Y') THEN(DO)                                          /*CAS016*/
               CPYF       FROMFILE(XLEERAPPD) TOFILE(LEERAPPD) +
                          MBROPT(*REPLACE)                                                /*CAS016*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(LEERAPPD))                                               /*CAS016*/
               CPYF       FROMFILE(XLECFLSPD) TOFILE(LECFLSPD) +
                          MBROPT(*REPLACE)                                                /*CAS016*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(LECFLSPD))                                               /*CAS016*/
             ENDDO                                                                        /*CAS016*/
/**/                                                                                      /*CAS009*/
             ENDDO                                                                        /*CAS009*/
/**/                                                                                      /*CAS009*/
             ELSE       CMD(DO)                                                           /*CAS009*/
                                                                      /*CLE003*/
             IF COND((&CLE003) *EQ 'Y') THEN(DO)                                          /*CAS009*/
/**/                                                                                      /*251331*/
/* Back up original CLOAN* files */                                                       /*251331*/
/**/                                                                                      /*251331*/
             CPYF       FROMFILE(CLOANHH) TOFILE(NCLONHH) +
                          MBROPT(*REPLACE)                                                /*251331*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(NCLONHH))                                                  /*251331*/
             CPYF       FROMFILE(CLOANCL) TOFILE(NCLONCL) +
                          MBROPT(*REPLACE)                                                /*251331*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(NCLONCL))                                                  /*251331*/
             CPYF       FROMFILE(CLOANCK) TOFILE(NCLONCK) +
                          MBROPT(*REPLACE)                                                /*251331*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(NCLONCK))                                                  /*251331*/
             CPYF       FROMFILE(CLOANZ1) TOFILE(NCLONZ1) +
                          MBROPT(*REPLACE)                                                /*251331*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(NCLONZ1))                                                  /*251331*/
/**/                                                                                      /*251331*/
             CPYF       FROMFILE(HISTSHH) TOFILE(HIUPDHH) +
                          MBROPT(*REPLACE)                            /*CLE003*/
             CPYF       FROMFILE(HISTSHM) TOFILE(HIUPDHM) +
                          MBROPT(*REPLACE)                            /*CLE003*/
             CPYF       FROMFILE(HISTSHN) TOFILE(HIUPDHN) +
                          MBROPT(*REPLACE)                            /*CLE003*/
             CPYF       FROMFILE(HISTSHP) TOFILE(HIUPDHP) +
                          MBROPT(*REPLACE)                            /*CLE003*/
             CPYF       FROMFILE(HISTSHQ) TOFILE(HIUPDHQ) +
                          MBROPT(*REPLACE)                            /*CLE003*/
             CPYF       FROMFILE(HISTSZX) TOFILE(HIUPDZX) +
                          MBROPT(*REPLACE)                            /*CLE003*/
             ENDDO                                                                        /*CAS009*/
/**/                                                                                      /*CAS009*/
             IF COND((&CAS009) *EQ 'Y') THEN(DO)                                          /*CAS009*/
               CPYF       FROMFILE(LEEIRDPD) TOFILE(XLEEIRDPD) +
                          MBROPT(*REPLACE)                                                /*CAS009*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(XLEEIRDPD))                                              /*CAS009*/
             ENDDO                                                                        /*CAS009*/
/**/                                                                                      /*CAS009*/
             IF COND((&CAS016) *EQ 'Y') THEN(DO)                                          /*CAS016*/
 
               DLTF       FILE(XLEERAPPD)                                                 /*CAS016*/
               MONMSG     MSGID(CPF0000)                                                  /*CAS016*/
                                                                                          /*CAS016*/
               CPYF       FROMFILE(LEERAPPD) TOFILE(&TOLIB/XLEERAPPD) +
                          CRTFILE(*YES)                                                   /*CAS016*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*CAS016*/
                                                                                          /*CAS016*/
               CPYF       FROMFILE(LECFLSPD) TOFILE(XLECFLSPD) +
                          MBROPT(*REPLACE)                                                /*CAS016*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(XLECFLSPD))                                              /*CAS016*/
             ENDDO                                                                        /*CAS016*/
             CHGVAR     VAR(&STUS) VALUE('Y')                         /*CLE003*/
/**/                                                                  /*CLE003*/
             CALL       PGM(CB0150) PARM(&CONAM &COSEQ &STUS)         /*CLE003*/
             ENDDO                                                    /*CLE003*/
/**/
/* CLEAR FILES FOR LE0370 */
             CLRPFM     FILE(LAUPDDH)
             CLRPFM     FILE(LAUPDDK)
             CLRPFM     FILE(LAUPDZ1)
             CLRPFM     FILE(ACTN1DH)
             CLRPFM     FILE(ACTN1DK)
             CLRPFM     FILE(ACTN1DN)
             CLRPFM     FILE(ACTN1ZX)
             CLRPFM     FILE(REVPDDP)                                 /*180044*/
/**/
/* CLEAR FILES FOR LE0390 */
             CLRPFM     FILE(LOUPDHH)
             CLRPFM     FILE(LOUPDCL)
             CLRPFM     FILE(LOUPDCK)
             CLRPFM     FILE(LOUPDZ1)
             CLRPFM     FILE(RATESHH)
             CLRPFM     FILE(RATESRT)
             CLRPFM     FILE(RATESZX)
             CLRPFM     FILE(ACTN3DH)
             CLRPFM     FILE(ACTN3DK)
             CLRPFM     FILE(ACTN3DN)
             CLRPFM     FILE(ACTN3ZX)
             CLRPFM     FILE(RVLNSHH)
             CLRPFM     FILE(RVLNSRV)
             CLRPFM     FILE(RVLNST2)
                                                                     /*S01408*/
/*/COPY WNCPYSRC,LEC0603001                                          */
                                                                     /*S01408*/
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEI)                  * *S01194*/
/*********** OVRDBF     FILE(TABLED) TOFILE(TABLEEI) SHARE(*NO)      * *S01194*/
/**/                                                                  /*S01427*/
/*  MIDAS/CHIPS LENDING                                          */   /*S01427*/
             RTVDTAARA  DTAARA(*LIBL/MMOD) RTNVAR(&MMOD)              /*S01427*/
             IF         COND(%SST(&MMOD 43 1) *EQ 'Y') THEN(DO)       /*S01427*/
             CLRPFM     FILE(*LIBL/MCRXCTT)                           /*S01427*/
             CALL       PGM(*LIBL/MC0060)                             /*S01427*/
             ENDDO                                                    /*S01427*/
/**/                                                                  /*127731*/
/* Check if CLE005 is installed */                                    /*127731*/
/**/                                                                  /*127731*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*127731*/
             CHGVAR     VAR(&SARD) VALUE('CLE005')                    /*127731*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*127731*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE005) VALUE('Y'))                    /*127731*/
/**/                                                                  /*S01427*/
          IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)                 /*S01427*/
/**/
/* LOAN AMENDMENTS UPDATE PHASE ONE                                 */
             IF         COND(&CLE005 *EQ 'Y') THEN(DO)                /*127731*/
             CALL       PGM(LE0373)                                   /*127731*/
             ENDDO                                                    /*127731*/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)              /*127731*/
             IF         COND((&CAS016) *EQ 'Y') THEN(DO)                                  /*CAS016*/
                  CLRPFM     FILE(LEAMDTPD)                                               /*CAS016*/
                  MONMSG     MSGID(CPF0000)                                               /*CAS016*/
             ENDDO                                                                        /*CAS016*/
/**********  CALL PGM(LE0370) */                                                          /*CLE134*/
/*/COPY WNCPYSRC,LEH01433                                            */
             CALL       PGM(LE0370) PARM(&CONAM)                                          /*CLE134*/
             ENDDO                                                    /*127731*/
/**/
/*********** DLTOVR     FILE(TABLED)                                 * *S01194*/
/**/
             IF      COND(%SWITCH(XXXXXXX0)) THEN(DO)                 /*134725*/
                CHGVAR     VAR(&RTCD) VALUE('       ')                /*134725*/
                CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                /*134725*/
                CHGVAR     VAR(&SARD) VALUE('CLE004')                 /*134725*/
                CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT) /*134725*/
                IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE004) VALUE('Y'))                    /*134725*/
                CHGVAR     VAR(&RTCD) VALUE('       ')                /*185526*/
                CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                /*185526*/
                CHGVAR     VAR(&SARD) VALUE('CEU020')                 /*185526*/
                CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT) /*185526*/
                IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CEU020) VALUE('Y'))                    /*185526*/
/***********    IF      COND(&CLE004 *EQ 'Y') THEN(DO)         /*134725 185526*/
             IF         COND(&CLE004 *EQ 'Y' *OR &CEU020 *EQ 'Y') +
                          THEN(DO)                                    /*185526*/
/**********        CALL PGM(LE0389)                                                /*134725 CLE134*/
                 CALL       PGM(LE0389) PARM(&CONAM)                                      /*CLE134*/
                ENDDO                                                 /*134725*/
             ENDDO                                                    /*134725*/
/*                                                                    /*134725*/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
/* CUSTOMER LOANS UPDATE PHASE ONE                                  */
/**********     CALL PGM(LE0390)                                                          /*CLE134*/
               CALL       PGM(LE0390) PARM(&CONAM)                                        /*CLE134*/
/**/
                IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
             IF COND((&CLE003) *EQ 'Y') THEN(DO)                      /*CLE003*/
/**/
/**********        CALL PGM(LE0371)                                                /*CLE003 CLE134*/
               CALL PGM(LE0371) PARM(&CONAM)                                              /*CLE134*/
             ENDDO                                                    /*CLE003*/
             ENDDO                                                    /*CLE003*/
/* REVERSED LOANS HISTORY REPORT                                    */
                                                                     /*S01408*/
/*/COPY WNCPYSRC,LEC0603002                                          */
                                                                     /*S01408*/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)           /*CLE003*/
                   CALL PGM(LE0380)
             ENDDO                                                    /*CLE003*/
                                                                     /*S01408*/
/*/COPY WNCPYSRC,LEC0603003                                          */
                                                                     /*S01408*/
/**/
/* CLEAR FILES NO LONGER REQUIRED, IF JOB TERMINATED SUCCESSFULLY   */
                   IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/* PF/RVLNS&& FILES ARE OUTPUT FROM LE0390 AND USED IN LE0380       */
                      CLRPFM     FILE(RVLNSHH)
                      CLRPFM     FILE(RVLNSRV)
                      CLRPFM     FILE(RVLNST2)
/* PF/ACTN1&& FILES ARE OUTPUT FROM LE0370 AND USED IN LE0390       */
/*                                                               */   /*CLE003*/
/*   Save file data to assist with future support of product     */   /*CLE003*/
/*                                                                    /*CLE003*/
/*                    CLRPFM     FILE(ACTN1DH)       */               /*CLE003*/
/*                    CLRPFM     FILE(ACTN1DK)       */               /*CLE003*/
/*                    CLRPFM     FILE(ACTN1DN)       */               /*CLE003*/
/*                    CLRPFM     FILE(ACTN1ZX)       */               /*CLE003*/
                                                                     /*S01408*/
/*/COPY WNCPYSRC,LEC0603004                                          */
                                                                     /*S01408*/
/**/
/* CREATE NEW MIDAS/CHIPS RECORD FILE WITH NEW TRAILER FROM MC0060 */ /* +
S01427*/
                     IF COND(%SST(&MMOD 43 1) *EQ 'Y') THEN(DO)       /*S01427*/
CLRPFM     FILE(*LIBL/MCRECDD)                                        /*S01427*/
CLRPFM     FILE(*LIBL/MCRECTT)                                        /*S01427*/
CPYF       FROMFILE(*LIBL/MCRXCTT) TOFILE(*LIBL/MCRECTT) MBROPT(*ADD) +
             FMTOPT(*NOCHK)                                           /*S01427*/
                     ENDDO                                            /*S01427*/
             IF COND((&CLE003) *EQ 'Y') THEN(DO)                      /*CLE003*/
             CHGVAR     VAR(&STUS) VALUE('N')                         /*CLE003*/
/**/                                                                  /*CLE003*/
             CALL       PGM(CB0150) PARM(&CONAM &COSEQ &STUS)         /*CLE003*/
/**/                                                                  /*S01427*/
                   ENDDO
/**/
                ENDDO
/**/
             ENDDO
/**/                                                                  /*S01427*/
          ENDDO                                                       /*S01427*/
/**/
/*********** DLTOVR     FILE(TABLE)                                  * *S01194*/
/**/
/**/                                                                  /*S01427*/
/*   E R R O R   M E S S A G E S                                */    /*S01427*/
/**/                                                                  /*S01427*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01427*/
                   RTVDTAARA  DTAARA(*LIBL/LDA) RTNVAR(&LDA)          /*S01427*/
                  CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44)) /*S01427*/
SNDPGMMSG  MSGID(MEM0001) MSGF(*LIBL/MIDAS) MSGDTA(&MEM) TOMSGQ(*LIBL/MOPERQ +
             *LIBL/MRUNQ)                                             /*S01427*/
                   GOTO       CMDLBL(ENDPGM)                          /*S01427*/
             ENDDO                                                    /*S01427*/
/**/                                                                  /*S01427*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*S01427*/
SNDPGMMSG  MSGID(MEM0002) MSGF(*LIBL/MIDAS) MSGDTA(&MEM) TOMSGQ(*LIBL/MOPERQ +
             *LIBL/MRUNQ)                                            /*S01427*/
             ENDDO                                                    /*S01427*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM                                                   /*S01427*/
/************ENDPGM    */                            /*S01427*/
