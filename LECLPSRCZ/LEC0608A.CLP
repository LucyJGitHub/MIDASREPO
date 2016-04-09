/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Generate Accounting Entries')                */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                       */
/*                                                                  */
/*     LEC0608A -  GENERATE ACCOUNTING ENTRIES                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. AR1055617          Date 12Nov12              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/*                      AR824348           Date 02Sep11              */
/*                      CER049             Date 06Dec10              */
/*                      CER059             Date 19Jul10              */
/*                      BUG23276           Date 10Mar09              */
/*                      CER044             Date 19May08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.03 --------------------------------------------*/
/*                    211664             Date  13Nov02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                    CMX001             Date  18Apr01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                    S01408             DATE  22FEB95              */
/*                    LN0465             DATE  03JUL90              */
/*                    S01194             DATE  08FEB90              */
/*                    S01179             DATE  14/09/88             */
/*                    E80624             DATE  28/04/87             */
/*                    S01094             DATE  03/07/86             *  *S01094*/
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*     AR1055617 - Additional code changes based on code            */
/*                 review                                           */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       AR824348 - Naming convention errors                        */
/*       CER049 - Stamp Tax                                         */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23276 - Items with Customers set up as Banks not shown   */
/*       CER044 - German Features LF035-00 AWV Reporting             */
/*       211664 - LE0470 ended in error but this wasn't reported in */
/*                the COB monitor. Change to CMX001 - only call     */
/*                MXC0490 if LE0470 completed successfully.         */
/*       CMX001 - Meridian Export                                   */
/*       S01408 - Addition of core hook LEC0608AMP                  */
/*                Addition of core hook LEC0608AIN                  */
/*                Addition of core hook LEC0608AM1                  */
/*                Addition of core hook LEC0608AM2                  */
/*     LN0465  -  AMENDED TO CALL CB0175 TO SET ON HALT AFTER       */
/*                COMPONENT FLAG IF APPROPRIATE                     */
/*                                                                  */
/*     S01194  -  NEW STANDING DATA                                 *  *E80624*/
/*                                                                  */
/*     S01179  -  AS400 INCORPORATION                               *  *E80624*/
/*                                                                  */
/*     E80624  -  LEC0608 USES U5 TO INDICATE PRESENCE OF THE       *  *E80624*/
/*                RETAIL MODULE AND LE0470 (CALLED BY LEC0608)      *  *E80624*/
/*                USES U2.                                          *  *E80624*/
/*     S01094  -  LE0470 AMENDED AND NO LONGER USES TABLED -        */
/*                THEREFORE OVERRIDE REMOVED                        *  *S01094*/
/*                                                                  */
/********************************************************************/
/************PGM        PARM(&POST)                                   /*LN0465*/
/**********  PGM        PARM(&POST &NAM &SEQ)                                      /*LN0465 CLE134*/
             PGM        PARM(&POST &NAM &SEQ &RERUN)                                      /*CLE134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&POST) TYPE(*CHAR) LEN(1)
/*           DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
/*           DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
             DCL VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL VAR(&LESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&NAM) TYPE(*CHAR) LEN(10)                 /*LN0465*/
             DCL        VAR(&SEQ) TYPE(*DEC) LEN(5 0)                 /*LN0465*/
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)               /*CMX001*/
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)               /*CMX001*/
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)               /*CMX001*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CMX001*/
             DCL        VAR(&CMX001) TYPE(*CHAR) LEN(1)  VALUE('N')   /*CMX001*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')                                                /*CER044*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*CER044*/
             DCL        VAR(&CER044) TYPE(*CHAR) LEN(1) +
                          VALUE(' ')                                                      /*CER044*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)  +
                          VALUE('CER044')                                                 /*CER044*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CER044*/
             DCL        VAR(&CLE134) TYPE(*CHAR) LEN(1)  VALUE('N')                       /*CLE134*/
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)                                     /*CLE134*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,LEC0608AMP                                           /*S01408*/
/* */                                                                 /*S01408*/
/**/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,LEC0608AIN                                           /*S01408*/
/* */                                                                 /*S01408*/
/**********  CLRPFM     FILE(LE8110PD) */                                        /*CER049 AR824348*/
             CLRPFM     FILE(LESTGEPD)                                                    /*CER049*/
             MONMSG     MSGID(CPF3142)                                                    /*CER049*/
/**/                                                                  /*CMX001*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             RTVDTAARA  DTAARA(LEPDCL) RTNVAR(&LEPDCL)                                    /*CLE134*/
                 IF         COND(%SUBSTRING(&LEPDCL 1 1) *EQ 'N') +
                               THEN(GOTO CMDLBL(ENDPGM))                                  /*CLE134*/
             ENDDO                                                                        /*CLE134*/
/**  Check if Meridian export is installed                   */       /*CMX001*/
/**/                                                                  /*CMX001*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CMX001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CMX001*/
             CHGVAR     VAR(&SAR)  VALUE('CMX001')                    /*CMX001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CMX001*/
                                                                      /*CMX001*/
             IF         COND(&RTCD = '       ') +
                 THEN(CHGVAR VAR(&CMX001) VALUE('Y'))                 /*CMX001*/
                                                                      /*CMX001*/
/** Check if CLE134 is ON */                                                              /*CLE134*/
             CHGVAR     VAR(&SAR)  VALUE('CLE134')                                        /*CLE134*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CLE134*/
                                                                                          /*CLE134*/
             IF         COND(&RTCD = '       ') +
                           THEN(CHGVAR VAR(&CLE134) VALUE('Y'))                           /*CLE134*/
/**/                                                                                      /*CLE134*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
/** CLEAR PF/GELExx OR PF/GELE2xx */                                                      /*CLE134*/
                CLRPFM     FILE(GELELNHH)                                                 /*CLE134*/
                CLRPFM     FILE(GELELNPD)                                                 /*CLE134*/
                CLRPFM     FILE(GELELNZZ)                                                 /*CLE134*/
                                                                                          /*CLE134*/
/** OVERRIDE PF/GELExx */                                                                 /*CLE134*/
                OVRDBF     FILE(GELEHH) TOFILE(GELELNHH)                                  /*CLE134*/
                OVRDBF     FILE(GELEPD) TOFILE(GELELNPD)                                  /*CLE134*/
                OVRDBF     FILE(GELEZZ) TOFILE(GELELNZZ)                                  /*CLE134*/
                ENDDO                                                                     /*CLE134*/
             IF         COND(&RERUN *EQ '      ') THEN(DO)                                /*CLE134*/
/*   CLEAR PF/GELExx OR PF/GELE2xx                                  */
             IF         COND(&POST *EQ '1') THEN(DO)
                CLRPFM     FILE(GELEHH)
                CLRPFM     FILE(GELEPD)
                CLRPFM     FILE(GELEZZ)
             ENDDO
/**/
             IF         COND(&POST *EQ '5') THEN(DO)
                CLRPFM     FILE(GELE2HH)
                CLRPFM     FILE(GELE2PD)
                CLRPFM     FILE(GELE2ZZ)
             ENDDO
                ENDDO                                                                     /*CLE134*/
/**/
/**IF*RETAIL*MOD*SWITCH*5*-*GENERATE*ACCOUNTING*ENTRIES*-*CLEAR*GELE*  *E80624*/
/* IF RETAIL MOD SWITCH 2 - GENERATE ACCOUNTING ENTRIES - CLEAR GELE*  *E80624*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
/**/
             IF         COND(%SUBSTRING(&MMOD 3 1) *EQ 'Y') THEN(DO)
/***************CHGJOB     SWS(XXXX1XXX)*****************************  *E80624*/
                CHGJOB     SWS(X1XXXXXX)                              /*E80624*/
             ENDDO
/**/
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEI)                  * *S01194*/
/*********** OVRDBF     FILE(TABLED) TOFILE(TABLEEI) SHARE(*NO)     *  *S01094*/
/**/
             IF         COND(&RERUN *EQ '      ') THEN(DO)                                /*CLE134*/
             IF         COND(&POST *EQ '5') THEN(DO)
/**/
                OVRDBF     FILE(GELEHH) TOFILE(GELE2HH)
                OVRDBF     FILE(GELEPD) TOFILE(GELE2PD)
                OVRDBF     FILE(GELEZZ) TOFILE(GELE2ZZ)
/**/
             ENDDO
             ENDDO                                                                        /*CLE134*/
/**/
             SNDPGMMSG  MSG('CUSTOMER LENDING GENERATED ACCOUNT +
                        POSTINGS') TOMSGQ(MRUNQ)
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,LEC0608AM1                                           /*S01408*/
/* */                                                                 /*S01408*/
             CHGVAR     VAR(&SAR) VALUE('CER044')                                         /*CER044*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CER044*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CER044*/
             CHGVAR     VAR(&CER044) VALUE('Y')                                           /*CER044*/
             CPYF       FROMFILE(LKEY1DP) TOFILE(QTEMP/XXLKEY1DP) +
                          MBROPT(*ADD) CRTFILE(*YES)                                      /*CER044*/
             ENDDO                                                                        /*CER044*/
/**/
/**********  CALL       PGM(LE0470) */                                                    /*CLE134*/
             CALL       PGM(LE0470) PARM(&RERUN)                                          /*CLE134*/
/** Clear Extract file   */                                                               /*CER044*/
             IF         COND(&CER044 *EQ 'Y') THEN(DO)                                    /*CER044*/
/**********  CLRPFM     FILE(GLAWVLPD)  */                                   /*CER044*/ /*BUG23276*/
/**********  CLRPFM     FILE(GLAWXLPD)  */                                   /*CER044*/ /*BUG23276*/
             CALL       PGM(LE000471)                                                     /*CER044*/
             DLTF       FILE(QTEMP/XXLKEY1DP)                                             /*CER044*/
             ENDDO                                                                        /*CER044*/
                                                                      /*CMX001*/
/* Call MXC0490 only if LE0470 is successfull so that                 /*211664*/
/* LEC06A will be able to report any failure in LE0470.               /*211664*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*211664*/
                                                                      /*211664*/
             IF         COND(&CMX001 = 'Y') THEN(DO)                  /*CMX001*/
             CALL       PGM(MXC0490) PARM('LEC0608A' &POST)           /*CMX001*/
             ENDDO                                                    /*CMX001*/
                                                                      /*211664*/
             ENDDO                                                    /*211664*/
                                                                      /*CMX001*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,LEC0608AM2                                           /*S01408*/
/* */                                                                 /*S01408*/
             CALL       PGM(LE008110)                                                     /*CER049*/
             MONMSG     MSGID(CPF0000)                                                    /*CER049*/
/**/
/* IF ERROR HAS OCCURED CLEAR FILES AND END                          */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/*/COPY WNCPYSRC,LEC0608A03                                          */
/**/
             IF         COND(&RERUN *EQ '      ') THEN(DO)                             /*AR1055617*/
                IF         COND(&POST *EQ '1') THEN(DO)
/**/
                   CLRPFM     FILE(GELEHH)
                   CLRPFM     FILE(GELEPD)
                   CLRPFM     FILE(GELEZZ)
/**/
                ENDDO
/**/
                IF         COND(&POST *EQ '5') THEN(DO)
/**/
                   CLRPFM     FILE(GELE2HH)
                   CLRPFM     FILE(GELE2PD)
                   CLRPFM     FILE(GELE2ZZ)
/**/
                ENDDO
             ENDDO                                                                     /*AR1055617*/
                                                                                       /*AR1055617*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             CLRPFM     FILE(GELELNHH)                                                    /*CLE134*/
             CLRPFM     FILE(GELELNPD)                                                    /*CLE134*/
             CLRPFM     FILE(GELELNZZ)                                                    /*CLE134*/
             ENDDO                                                                        /*CLE134*/
/**/
             ENDDO
             ELSE          CMD(DO)
/*/COPY WNCPYSRC,LEC0608A04                                          */
/**/
/* IF NO A/C KEYS MISSING THEN CLEAR PF/LKEY2xx                      */
/* PF/LKEY1xx IS USED IN LEC0708 REPORTING                           */
                IF         COND(%SWITCH(XXX0XXXX)) THEN(DO)
/**********  IF         COND(&RERUN *EQ '      ') THEN(DO)           */         /*CLE134 AR1055617*/
/**/
/* REMOVE THE CLEAR OF THE LKEY2 FILES AS THEY NEED TO BE USED S01270*/
/* DURING THE TAKEON PHASE BEFORE THEY STOP BEING PRODUCED S01270  */
/*                 CLRPFM     FILE(LKEY2HH)                S01270  */
/*                 CLRPFM     FILE(LKEY2DP)                S01270  */
/*                 CLRPFM     FILE(LKEY2ZZ)                S01270  */
/**********  ENDDO                                                   */         /*CLE134 AR1055617*/
/**/
                ENDDO
/* IF A/C KEYS MISSING THEN CHECK D/LESTAT WHETHER TO CONTINUE OR NOT*/
                ELSE       CMD(DO)
/**/
                   RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
/**/
                   IF         COND(%SUBSTRING(&LESTAT 8 1) *EQ 'Y') +
                              THEN(DO)
/**/
                              SNDPGMMSG MSG('CUSTOMER LENDING +
                              A/C KEYS MISSING - PROCESSING +
                              CONTINUED') TOMSGQ(MRUNQ)
                   ENDDO
/**/
                   ELSE       CMD(DO)
/**/
/******SEND*HALT*MESSAGE*TO*MSTATUS*SO*THAT*END*OF*DAY*EXECTION      /*LN0465*/
/*     CALL CB0175 TO SET HALT AFTER COMPONENT FLAG ON               /*LN0465*/
/*     WILL HALT AT THE END OF THIS COMPONENT.                       */
/**/
                      SNDPGMMSG  MSG('CUSTOMER LENDING A/C KEYS +
                                 MISSING - PROCESSING HALTED') +
                                 TOMSGQ(MOPERQ MRUNQ)
/**********           SNDPGMMSG  MSG('HALT') TOMSGQ(MSTATUS)          /*LN0465*/
/**/                                                                  /*LN0465*/
                      CALL       PGM(CB0175) PARM(&NAM &SEQ)          /*LN0465*/
/**/                                                                  /*LN0465*/
/**/
                   ENDDO
/**/
                ENDDO
/*/COPY WNCPYSRC,LEC0608A02                                          */
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,LEC0608A01                                          */
/**********  ENDPGM    */                                                                 /*CLE134*/
ENDPGM:      ENDPGM                                                                       /*CLE134*/
