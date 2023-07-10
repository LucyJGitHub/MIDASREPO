/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Generate Accounting Entries')                */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Customer Lending Module                        */
/*                                                                   */
/*     LEC0608A -  GENERATE ACCOUNTING ENTRIES                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD049139           Date 16Jun23              */
/*       Prev Amend No. MD021383A          Date 16Jun23              */
/*                      MD046248           Date 27Oct17              */
/*                      AR1055617          Date 12Nov12              */
/*                      CLE134             Date 01Aug12              */
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
/*                    211664             Date  13Nov02               */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                    CMX001             Date  18Apr01               */
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                    S01408             DATE  22FEB95               */
/*                    LN0465             DATE  03JUL90               */
/*                    S01194             DATE  08FEB90               */
/*                    S01179             DATE  14/09/88              */
/*                    E80624             DATE  28/04/87              */
/*                    S01094             DATE  03/07/86              *  *S01094*/
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD049139 - Lending Fee are posting 1 day late for           */
/*                  auto settle fee on a calculated facility.        */
/*                 - MD061267 - Credit Lines (CLE025) fixes          */
/*       MD021383A - Credit lines shadow posting correction.         */
/*                   Introduced new LEC06A cob component to call     */
/*                   LE0470 on rerun in order to IAS postings.       */
/*                 - MD061267 - Credit Lines (CLE025) fixes          */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1055617 - Additional code changes based on code           */
/*                 review                                            */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       AR824348 - Naming convention errors                         */
/*       CER049 - Stamp Tax                                          */
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
                          Finastra International Limited +
                          2001')
             DCL        VAR(&POST) TYPE(*CHAR) LEN(1)
/*           DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
/*           DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
             DCL VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL VAR(&LESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&NAM) TYPE(*CHAR) LEN(10)                 /*LN0465*/
             DCL        VAR(&SEQ) TYPE(*DEC) LEN(5 0)                 /*LN0465*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                 /*MD021383A*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')                /*MD021383A*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE('N')                       /*MD021383A*/
/**********  DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)                      */ /*CMX001 MD021383A*/
/**********  DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)                      */ /*CMX001 MD021383A*/
/**********  DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)                      */ /*CMX001 MD021383A*/
/**********  DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                    */ /*CMX001 MD021383A*/
/**********  DCL        VAR(&CMX001) TYPE(*CHAR) LEN(1)  VALUE('N')          */ /*CMX001 MD021383A*/
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
/**********  DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                      */ /*CLE134 MD021383A*/
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)                                     /*CLE134*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
             DCL        VAR(&CMX001) TYPE(*CHAR) LEN(1)  VALUE('N')                     /*MD049139*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1)  VALUE('N')                     /*MD049139*/
/*                                                  */                                  /*MD049139*/
/* Check if Feature CLE025 is switched ON.          */                                  /*MD049139*/
/*                                                  */                                  /*MD049139*/
             RTVDTAARA  DTAARA(CLE025DTA) RTNVAR(&CLE025)                               /*MD049139*/
                                                                                        /*MD049139*/
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
/*****************************************************************************/ /*CMX001 MD021383A*/
/****Check*if*Meridian*export*is*installed************************************/ /*CMX001 MD021383A*/
/*****************************************************************************/ /*CMX001 MD021383A*/
/**********  CHGVAR     VAR(&RTCD) VALUE('       ')                          */ /*CMX001 MD021383A*/
/**********  CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                          */ /*CMX001 MD021383A*/
/**********  CHGVAR     VAR(&SAR)  VALUE('CMX001')                           */ /*CMX001 MD021383A*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)         */ /*CMX001 MD021383A*/
/**********                                                                  */ /*CMX001 MD021383A*/
/**********  IF         COND(&RTCD = '       ') +
/**********      THEN(CHGVAR VAR(&CMX001) VALUE('Y'))                        */ /*CMX001 MD021383A*/
/**********                                                                  */ /*CMX001 MD021383A*/
                                                                                        /*MD049139*/
             IF         COND(&CLE025 *NE 'Y') THEN(DO)                                  /*MD049139*/
                                                                                        /*MD049139*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                     /*MD049139*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                     /*MD049139*/
             CHGVAR     VAR(&SAR)  VALUE('CMX001')                                      /*MD049139*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                    /*MD049139*/
             IF         COND(&RTCD = '       ') +
                 THEN(CHGVAR VAR(&CMX001) VALUE('Y'))                                   /*MD049139*/
                                                                                        /*MD049139*/
             ENDDO                                                                      /*MD049139*/
             ELSE       CMD(DO)                                                         /*MD049139*/
                                                                                        /*MD049139*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                            /*MD021383A*/
             CHGVAR     VAR(%SST(&DPLIB 1 2)) VALUE(&SYSID)                            /*MD021383A*/
                                                                                       /*MD021383A*/
/* Check the current status of this component */                                       /*MD021383A*/
                                                                                       /*MD021383A*/
             CALL       PGM(CB0160) PARM(&NAM &SEQ &STAT)                              /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND((&SEQ *EQ 10012) *OR (&SEQ *EQ 10022)) +
                          THEN(DO)                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&STAT *EQ 'N') THEN(DO)                                /*MD021383A*/
                                                                                       /*MD021383A*/
                   DLTF       FILE(&DPLIB/ZGELEHH)                                     /*MD021383A*/
                   MONMSG     MSGID(CPF2105)                                           /*MD021383A*/
                   DLTF       FILE(&DPLIB/ZGELEPD)                                     /*MD021383A*/
                   MONMSG     MSGID(CPF2105)                                           /*MD021383A*/
                   DLTF       FILE(&DPLIB/ZGELEZZ)                                     /*MD021383A*/
                   MONMSG     MSGID(CPF2105)                                           /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&POST *EQ '1') THEN(DO)                             /*MD021383A*/
                      CPYF       FROMFILE(GELEHH) +
                                   TOFILE(&DPLIB/ZGELEHH) +
                                   CRTFILE(*YES)                                       /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                      CPYF       FROMFILE(GELEPD) +
                                   TOFILE(&DPLIB/ZGELEPD) +
                                   CRTFILE(*YES)                                       /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                      CPYF       FROMFILE(GELEZZ) +
                                   TOFILE(&DPLIB/ZGELEZZ) +
                                   CRTFILE(*YES)                                       /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&POST *EQ '5') THEN(DO)                             /*MD021383A*/
                      CPYF       FROMFILE(GELE2HH) +
                                   TOFILE(&DPLIB/ZGELEHH) +
                                   CRTFILE(*YES)                                       /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                      CPYF       FROMFILE(GELE2PD) +
                                   TOFILE(&DPLIB/ZGELEPD) +
                                   CRTFILE(*YES)                                       /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                      CPYF       FROMFILE(GELE2ZZ) +
                                   TOFILE(&DPLIB/ZGELEZZ) +
                                   CRTFILE(*YES)                                       /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&STAT *EQ 'Y') THEN(DO)                                /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&POST *EQ '1') THEN(DO)                             /*MD021383A*/
                      CPYF       FROMFILE(ZGELEHH) TOFILE(GELEHH) +
                                   MBROPT(*REPLACE)                                    /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GELEHH))                           /*MD021383A*/
                      CPYF       FROMFILE(ZGELEPD) TOFILE(GELEPD) +
                                   MBROPT(*REPLACE)                                    /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GELEPD))                           /*MD021383A*/
                      CPYF       FROMFILE(ZGELEZZ) TOFILE(GELEZZ) +
                                   MBROPT(*REPLACE)                                    /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GELEZZ))                           /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&POST *EQ '5') THEN(DO)                             /*MD021383A*/
                      CPYF       FROMFILE(ZGELEHH) TOFILE(GELE2HH) +
                                   MBROPT(*REPLACE)                                    /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GELE2HH))                          /*MD021383A*/
                      CPYF       FROMFILE(ZGELEPD) TOFILE(GELE2PD) +
                                   MBROPT(*REPLACE)                                    /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GELEPD))                           /*MD021383A*/
                      CPYF       FROMFILE(ZGELEZZ) TOFILE(GELE2ZZ) +
                                   MBROPT(*REPLACE)                                    /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GELE2ZZ))                          /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
/* Update restart indicator to 'Y' */                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
             CHGVAR     VAR(&STAT) VALUE('Y')                                          /*MD021383A*/
             CALL       PGM(CB0150) PARM(&NAM &SEQ &STAT)                              /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                      /*MD049139*/
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
                                                                                       /*MD021383A*/
/**********  IF         COND((&SEQ *EQ 10014) *OR (&SEQ *EQ 10024)) +  */     /*MD021383A MD049139*/
/**********               THEN(DO)                                     */     /*MD021383A MD049139*/
             IF         COND(((&CLE025 *EQ 'Y') *AND +
                              ((&SEQ *EQ 10014) *OR +
                               (&SEQ *EQ 10024))) *OR +
                             (&CLE025 *NE 'Y')) THEN(DO)                                /*MD049139*/
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
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                  /*MD049139*/
/* Clear PF/GELE3xx or PF/GELE4xx */                                                   /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND((&SEQ *EQ 10012) *OR (&SEQ *EQ 10022)) +
                          THEN(DO)                                                     /*MD021383A*/
                IF         COND(&POST *EQ '1') THEN(DO)                                /*MD021383A*/
                   CLRPFM     FILE(GELE3HH)                                            /*MD021383A*/
                   CLRPFM     FILE(GELE3PD)                                            /*MD021383A*/
                   CLRPFM     FILE(GELE3ZZ)                                            /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&POST *EQ '5') THEN(DO)                                /*MD021383A*/
                   CLRPFM     FILE(GELE4HH)                                            /*MD021383A*/
                   CLRPFM     FILE(GELE4PD)                                            /*MD021383A*/
                   CLRPFM     FILE(GELE4ZZ)                                            /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
             ENDDO                                                                      /*MD049139*/
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
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                  /*MD049139*/
             IF         COND((&SEQ *EQ 10014) *OR (&SEQ = 10024)) +
                          THEN(DO)                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
             OVRDBF     FILE(LERKEY) TOFILE(LERKEY3)                                   /*MD021383A*/
             ENDDO                                                                      /*MD049139*/
             ENDDO                                                                      /*MD049139*/
             IF         COND(((&CLE025 *EQ 'Y') *AND +
                              ((&SEQ *EQ 10014) *OR +
                               (&SEQ *EQ 10024))) *OR +
                             (&CLE025 *NE 'Y')) THEN(DO)                                /*MD049139*/
             IF         COND(&POST *EQ '5') THEN(DO)
/**/
                OVRDBF     FILE(GELEHH) TOFILE(GELE2HH)
                OVRDBF     FILE(GELEPD) TOFILE(GELE2PD)
                OVRDBF     FILE(GELEZZ) TOFILE(GELE2ZZ)
/**/
             ENDDO
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                  /*MD049139*/
             IF         COND((&SEQ *EQ 10012) *OR (&SEQ *EQ 10022)) +
                          THEN(DO)                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
               OVRDBF     FILE(LERKEY) TOFILE(LERKEY2)                                 /*MD021383A*/
                                                                                       /*MD021383A*/
               IF         COND(&POST *EQ '1') THEN(DO)                                 /*MD021383A*/
                  OVRDBF     FILE(GELEHH) TOFILE(GELE3HH)                              /*MD021383A*/
                  OVRDBF     FILE(GELEPD) TOFILE(GELE3PD)                              /*MD021383A*/
                  OVRDBF     FILE(GELEZZ) TOFILE(GELE3ZZ)                              /*MD021383A*/
               ENDDO                                                                   /*MD021383A*/
                                                                                       /*MD021383A*/
               IF         COND(&POST *EQ '5') THEN(DO)                                 /*MD021383A*/
                  OVRDBF     FILE(GELEHH) TOFILE(GELE4HH)                              /*MD021383A*/
                  OVRDBF     FILE(GELEPD) TOFILE(GELE4PD)                              /*MD021383A*/
                  OVRDBF     FILE(GELEZZ) TOFILE(GELE4ZZ)                              /*MD021383A*/
               ENDDO                                                                   /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
             ENDDO                                                                      /*MD049139*/
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
             ENDDO
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                  /*MD049139*/
                                                                                       /*MD021383A*/
             DLTOVR     FILE(LERKEY)                                                   /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND((&SEQ *EQ 10024) *OR (&SEQ *EQ 10012) +
                          *OR (&SEQ = 10022)) THEN(DO)                                 /*MD021383A*/
                DLTOVR     FILE(GELEHH)                                                /*MD021383A*/
                DLTOVR     FILE(GELEPD)                                                /*MD021383A*/
                DLTOVR     FILE(GELEZZ)                                                /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
             ENDDO                                                                      /*MD049139*/
                                                                      /*CMX001*/
/* Call MXC0490 only if LE0470 is successfull so that                 /*211664*/
/* LEC06A will be able to report any failure in LE0470.               /*211664*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*211664*/
                                                                      /*211664*/
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                  /*MD049139*/
             IF         COND((&SEQ *EQ 10014) *OR (&SEQ *EQ 10024)) +
                          THEN(DO)                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
                CLRPFM     FILE(LKEY1SHH)                                              /*MD021383A*/
                CLRPFM     FILE(LKEY1SDP)                                              /*MD021383A*/
                CLRPFM     FILE(LKEY1SZZ)                                              /*MD021383A*/
                                                                                       /*MD021383A*/
                CPYF       FROMFILE(LKEY1HH) TOFILE(&DPLIB/LKEY1SHH) +
                             MBROPT(*REPLACE)                                          /*MD021383A*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(&DPLIB/LKEY1SHH))                        /*MD021383A*/
                CPYF       FROMFILE(LKEY1DP) TOFILE(&DPLIB/LKEY1SDP) +
                             MBROPT(*REPLACE)                                          /*MD021383A*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(&DPLIB/LKEY1SDP))                        /*MD021383A*/
                CPYF       FROMFILE(LKEY1ZZ) TOFILE(&DPLIB/LKEY1SZZ) +
                             MBROPT(*REPLACE)                                          /*MD021383A*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(&DPLIB/LKEY1SZZ))                        /*MD021383A*/
                                                                                       /*MD021383A*/
                CPYF       FROMFILE(LKEYFEA) TOFILE(&DPLIB/LKEYFESA) +
                             MBROPT(*REPLACE)                                          /*MD021383A*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(&DPLIB/LKEYFESA))                        /*MD021383A*/
                CPYF       FROMFILE(LKEYFED) TOFILE(&DPLIB/LKEYFESD) +
                             MBROPT(*REPLACE)                                          /*MD021383A*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(&DPLIB/LKEYFESD))                        /*MD021383A*/
                CPYF       FROMFILE(LKEYFEZ) TOFILE(&DPLIB/LKEYFESZ) +
                             MBROPT(*REPLACE)                                          /*MD021383A*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(&DPLIB/LKEYFESZ))                        /*MD021383A*/
                                                                                       /*MD021383A*/
                CLRPFM     FILE(LKEY1DP)                                               /*MD021383A*/
                CLRPFM     FILE(LKEYFED)                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                CALL       PGM(LE000474) PARM('LKEY1ZZ' 'Reset')                       /*MD021383A*/
                CALL       PGM(LE000474) PARM('LKEYFEZ' 'Reset')                       /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND((&SEQ *EQ 10012) *OR (&SEQ *EQ 10022)) +
                          THEN(DO)                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&POST = '1') THEN(DO)                                  /*MD021383A*/
                   CPYF       FROMFILE(GELE3PD) TOFILE(GELEPD) +
                                MBROPT(*ADD)                                           /*MD021383A*/
                   CALL       PGM(LE000474) PARM('GELE3ZZ' 'Update')                   /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&POST = '5') THEN(DO)                                  /*MD021383A*/
                   CPYF       FROMFILE(GELE4PD) TOFILE(GELE2PD) +
                                MBROPT(*ADD)                                           /*MD021383A*/
                   CALL       PGM(LE000474) PARM('GELE4ZZ' 'Update')                   /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
                CPYF       FROMFILE(&DPLIB/LKEY1SDP) TOFILE(LKEY1DP) +
                             MBROPT(*ADD)                                              /*MD021383A*/
                MONMSG     MSGID(CPF0000)                                              /*MD021383A*/
                CPYF       FROMFILE(&DPLIB/LKEYFESD) TOFILE(LKEYFED) +
                             MBROPT(*ADD)                                              /*MD021383A*/
                MONMSG     MSGID(CPF0000)                                              /*MD021383A*/
                                                                                       /*MD021383A*/
                CALL       PGM(LE000474) PARM('LKEY1ZZ' 'Update')                      /*MD021383A*/
                CALL       PGM(LE000474) PARM('LKEYFEZ' 'Update')                      /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
/**********  IF         COND(&CMX001 = 'Y') THEN(DO)                         */ /*CMX001 MD021383A*/
/**********  CALL       PGM(MXC0490) PARM('LEC0608A' &POST)                  */ /*CMX001 MD021383A*/
/**********  ENDDO                                                           */ /*CMX001 MD021383A*/
             ENDDO                                                                      /*MD049139*/
             ELSE       CMD(DO)                                                         /*MD049139*/
             IF         COND(&CMX001 = 'Y') THEN(DO)                                    /*MD049139*/
             CALL       PGM(MXC0490) PARM('LEC0608A' &POST)                             /*MD049139*/
             ENDDO                                                                      /*MD049139*/
             ENDDO                                                                      /*MD049139*/
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
/**********  IF         COND((&SEQ *EQ 10014) *OR (&SEQ *EQ 10024)) +  */     /*MD021383A MD049139*/
/**********               THEN(DO)                                     */     /*MD021383A MD049139*/
             IF         COND(((&CLE025 *EQ 'Y') *AND +
                              ((&SEQ *EQ 10014) *OR +
                               (&SEQ *EQ 10024))) *OR +
                             (&CLE025 *NE 'Y')) THEN(DO)                                /*MD049139*/
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
                                                                                       /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                  /*MD049139*/
             IF         COND((&SEQ *EQ 10012) *OR (&SEQ *EQ 10022)) +
                          THEN(DO)                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&POST *EQ '1') THEN(DO)                                /*MD021383A*/
                   CLRPFM     FILE(GELE3HH)                                            /*MD021383A*/
                   CLRPFM     FILE(GELE3PD)                                            /*MD021383A*/
                   CLRPFM     FILE(GELE3ZZ)                                            /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&POST *EQ '5') THEN(DO)                                /*MD021383A*/
                   CLRPFM     FILE(GELE4HH)                                            /*MD021383A*/
                   CLRPFM     FILE(GELE4PD)                                            /*MD021383A*/
                   CLRPFM     FILE(GELE4ZZ)                                            /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
             ENDDO                                                                      /*MD049139*/
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
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                  /*MD049139*/
                                                                                       /*MD021383A*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                               /*MD021383A*/
                                                                                       /*MD021383A*/
/* Update restart indicator to 'N' */                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
             CHGVAR     VAR(&STAT) VALUE('N')                                          /*MD021383A*/
             CALL       PGM(CB0150) PARM(&NAM &SEQ &STAT)                              /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                      /*MD049139*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,LEC0608A01                                          */
/**********  ENDPGM    */                                                                 /*CLE134*/
ENDPGM:      ENDPGM                                                                       /*CLE134*/
