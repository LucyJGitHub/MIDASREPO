/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AK SE A/c Key Gen. - Select keys')              */
/********************************************************************/
/*                                                                  */
/*   Midas - Account Key Generator                                  */
/*                                                                  */
/*   AKC61 - SE A/C Key Generation - Select Logical View of         */
/*                                   Generated Keys.                */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG9343            Date 11Dec05              */
/*                      CAS006             Date 21Jan03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      159026             Date 20Apr99              */
/*                      CAC002             Date 15Sep96              */
/*                  S01408             Date  26FEB96                */
/*                  S01447             Date  10FEB94                */
/*                  S01315             Date  30JAN91                */
/*                  E22116             Date  30MAY90                */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   MD046248 - Finastra Rebranding                                 */
/*   BUG9343- HG amount code  should not show if CAS007 is off.     */
/*   CAS006 - Hedge Accounting Phase B                              */
/*   159026 - Corporate Actions. Problems with Account Keys         */
/*            Generator Program.                                    */
/*   CAC002 - Profit Centre Accounting Development - Phase 2        */
/*            Add new options for Margin Amount.                    */
/*   S01408 - Addition of core hook AKC61MPS                        */
/*            Addition of core hook AKC61001                        */
/*   S01447 - SE Withholding tax.                                   */
/*   S01315 - Upgrade to SD standards                               */
/*            Program name changed from SEC42 to AKC61.             */
/*   E22116 - Help System.Recompiled over changed dspf SEC42DF  */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/**/
             PGM        PARM(&OVRD)
/**/
                                                             /*S01315*/
/*           DCLF       FILE(*LIBL/SEC42DF) */
             DCLF       FILE(*LIBL/AKC61DF)
                                                             /*S01315*/
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)                /*S01447*/
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*S01447*/
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('S01447')                             /*S01447*/
             DCL        VAR(&CSE007) TYPE(*CHAR) LEN(1) VALUE('N')    /*159026*/
             DCL        VAR(&CAS006) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CAS006*/
             DCL        VAR(&CAS007) TYPE(*CHAR) LEN(1) VALUE('N')                       /*BUG9343*/
/**/
                                                             /*S01315*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                             /*S01315*/
             DCL        VAR(&OVRD) TYPE(*CHAR) LEN(10)
                                                             /*S01315*/
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RUNA) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CAC002*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*FIRST')                             /*CAC002*/
             DCL        VAR(&SDMMOD) TYPE(*CHAR) LEN(128)             /*CAC002*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,AKC61MPS                          */                 /*S01408*/
                                                                      /*S01408*/
/**/                                                                  /*CAC002*/
/* Access Module Details */                                           /*CAC002*/
/**/                                                                  /*CAC002*/
             CHGVAR     VAR(&IN20) VALUE('0')                         /*CAC002*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &SDMMOD)       /*CAC002*/
/**/                                                                  /*CAC002*/
/* Database error  */                                                 /*CAC002*/
/**/                                                                  /*CAC002*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*CAC002*/
                SNDPGMMSG  MSG('Error on access to ICD file +
                              SDMMODPD') TOMSGQ(MOPERQ)               /*CAC002*/
                CHGJOB     JOB(XXXXXX11)                              /*CAC002*/
                GOTO       CMDLBL(EXIT)                               /*CAC002*/
             ENDDO                                                    /*CAC002*/
/**/                                                                  /*CAC002*/
/* Check if Analytical Accounting module is installed  */             /*CAC002*/
/**/                                                                  /*CAC002*/
             IF         COND(%SST(&SDMMOD 100 1) *EQ 'Y') THEN(DO)    /*CAC002*/
                CHGVAR     VAR(&IN20) VALUE('1')                      /*CAC002*/
             ENDDO                                                    /*CAC002*/
/**/                                                                  /*CAC002*/
             CHGVAR     VAR(&IN11) VALUE('0')
/**/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)      /*S01447*/
/**/                                                                  /*S01447*/
/* ERROR */                                                           /*S01447*/
/**/                                                                  /*S01447*/
             IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)                         /*S01447*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)                        /*S01447*/
             CHGJOB (XXXXXX11)                                        /*S01447*/
             GOTO       CMDLBL(EXIT)
             ENDDO                                                    /*S01447*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,AKC61001                          */                 /*S01408*/
                                                                      /*S01408*/
/**/                                                                  /*S01447*/
/* Switchable Feature installed                                         S01447*/
/**/                                                                  /*S01447*/
             IF         COND(&SRTCD *EQ '       ') THEN(DO)           /*S01447*/
             CHGVAR     VAR(&IN11) VALUE('1')                         /*S01447*/
             ENDDO                                                    /*S01447*/
/**/                                                                  /*159026*/
             CHGVAR     VAR(&SRTCD) VALUE('       ')                  /*159026*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                  /*159026*/
             CHGVAR     VAR(&SSARD) VALUE('CSE007')                   /*159026*/
/**/                                                                  /*159026*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)      /*159026*/
/**/                                                                  /*159026*/
             IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)                         /*159026*/
             SNDPGMMSG  MSG('AOSARDR0 FOR "CSE007" - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)                        /*159026*/
             CHGJOB (XXXXXX11)                                        /*159026*/
             GOTO       CMDLBL(EXIT1)                                 /*159026*/
             ENDDO                                                    /*159026*/
/**/                                                                  /*159026*/
/* Switchable Feature installed                                       /*159026*/
/**/                                                                  /*159026*/
             CHGVAR     VAR(&IN50) VALUE('0')                         /*159026*/
             IF         COND(&SRTCD *EQ '       ') THEN(DO)           /*159026*/
                 CHGVAR     VAR(&CSE007) VALUE('Y')                   /*159026*/
                 CHGVAR     VAR(&IN50) VALUE('1')                     /*159026*/
             ENDDO                                                    /*159026*/
/**/                                                                  /*159026*/
                                                                                          /*CAS006*/
/** Check if CAS006 (Hedge Accounting Phase B) is installed */                            /*CAS006*/
                                                                                          /*CAS006*/
             CHGVAR     VAR(&SRTCD) VALUE('       ')                                      /*CAS006*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                      /*CAS006*/
             CHGVAR     VAR(&SSARD) VALUE('CAS006')                                       /*CAS006*/
                                                                                          /*CAS006*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)                          /*CAS006*/
                                                                                          /*CAS006*/
             IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CAS006*/
             SNDPGMMSG  MSG('AOSARDR0 FOR "CAS006" - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)                                            /*CAS006*/
             CHGJOB (XXXXXX11)                                                            /*CAS006*/
             GOTO       CMDLBL(EXIT1)                                                     /*CAS006*/
             ENDDO                                                                        /*CAS006*/
                                                                                          /*CAS006*/
/** Switchable Feature installed */                                                       /*CAS006*/
                                                                                          /*CAS006*/
             CHGVAR     VAR(&IN55) VALUE('0')                                             /*CAS006*/
             IF         COND(&SRTCD *EQ '       ') THEN(DO)                               /*CAS006*/
                 CHGVAR     VAR(&CAS006) VALUE('Y')                                       /*CAS006*/
/**              CHGVAR     VAR(&IN55) VALUE('1')   */                            /*CAS006 BUG9343*/
             ENDDO                                                                        /*CAS006*/
                                                                                          /*CAS006*/
 
                                                                                         /*BUG9343*/
/** Check if CAS006 (Hedge Accounting Phase B) is installed */                           /*BUG9343*/
                                                                                         /*BUG9343*/
             CHGVAR     VAR(&SRTCD) VALUE('       ')                                     /*BUG9343*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                     /*BUG9343*/
             CHGVAR     VAR(&SSARD) VALUE('CAS007')                                      /*BUG9343*/
                                                                                         /*BUG9343*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)                         /*BUG9343*/
                                                                                         /*BUG9343*/
             IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)                                            /*BUG9343*/
             SNDPGMMSG  MSG('AOSARDR0 FOR "CAS007" - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)                                           /*BUG9343*/
             CHGJOB (XXXXXX11)                                                           /*BUG9343*/
             GOTO       CMDLBL(EXIT1)                                                    /*BUG9343*/
             ENDDO                                                                       /*BUG9343*/
                                                                                         /*BUG9343*/
/** Switchable Feature installed */                                                      /*BUG9343*/
                                                                                         /*BUG9343*/
             IF         COND(&SRTCD *EQ '       ') THEN(DO)                              /*BUG9343*/
                 CHGVAR     VAR(&CAS007) VALUE('Y')                                      /*BUG9343*/
             ENDDO                                                                       /*BUG9343*/
                                                                                         /*BUG9343*/
             IF         COND(&CAS006 *EQ 'Y' *AND &CAS007 *EQ 'Y')  +
                        THEN(DO)                                                         /*BUG9343*/
                 CHGVAR     VAR(&IN55) VALUE('1')                                        /*BUG9343*/
             ENDDO                                                                       /*BUG9343*/
                                                                                         /*BUG9343*/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&RUNA)
             RTVJOBA    JOB(&JOB) USER(&USRID)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGVAR     VAR(&INPUT1) VALUE(' ')
             CHGVAR     VAR(&INPUT2) VALUE('  ')
             CHGVAR     VAR(&IN03) VALUE('0')
                                                             /*S01315*/
             CHGVAR     VAR(&IN12) VALUE('0')
/*           CHGJOB     SWS(XX0XXXXX)                               */
/**/
/*   F3 or F12 pressed will set on switches 3 or 4 respectively     */
/**/
             CHGJOB     SWS(XX00XXXX)
/**/
/*           SNDRCVF    RCDFMT(SEC42R1)                              */
                                                             /*S01315*/
/* FIRST:      SNDRCVF    RCDFMT(SEC42R1)  */
 FIRST:      SNDRCVF    RCDFMT(AKC61R1)
                                                             /*S01315*/
             CHGJOB     SWS(XXX0XXXX)
             CHGVAR     VAR(&MSG) +
                          VALUE('                                     -
                                         ')
/**/
/*   F3 pressed  */
                                                             /*S01315*/
/**/
             IF         COND(&IN03) THEN(DO)
                        CHGJOB     SWS(XX1XXXXX)
                        GOTO       CMDLBL(MENU)
             ENDDO
                                                             /*S01315*/
/**/
/*   F12 pressed  */
/**/
             IF         COND(&IN12) THEN(DO)
                        CHGJOB     SWS(XXX1XXXX)
                        GOTO       CMDLBL(MENU)
             ENDDO
/**/
/*    No entry in field  */
/**/
/*********** IF         COND(&INPUT1 *EQ ' ') THEN(DO)                /*159026*/
             IF         COND((&INPUT1 *EQ ' ') *OR (&INPUT1 *EQ 'Z' +
                          *AND &CSE007 *EQ 'N')) THEN(DO)             /*159026*/
             CHGVAR     VAR(&MSG) VALUE('Invalid option entered')
             GOTO       CMDLBL(FIRST)
             ENDDO
/**/
/*           IF         COND((&INPUT1 *EQ 'X') *OR (&INPUT1 *EQ ' '))*/
/**/                                                                  /*159026*/
/*********** IF         COND(&INPUT1 *EQ 'X') THEN(DO)                /*159026*/
             IF         COND((&INPUT1 *EQ 'X' *AND &CSE007 *EQ 'N') +
                          *OR (&INPUT1 *EQ 'Z' *AND &CSE007 *EQ +
                          'Y')) THEN(DO)                              /*159026*/
/*           SNDRCVF    RCDFMT(SEC42R2)                              */
                                                             /*S01315*/
/* SECOND:     SNDRCVF    RCDFMT(SEC42R2)  */
 SECOND:     SNDRCVF    RCDFMT(AKC61R2)
                                                             /*S01315*/
             CHGVAR     VAR(&MSG) +
                          VALUE('                                     -
                                         ')
/**/
/*   F3 pressed  */
/**/
             IF         COND(&IN03) THEN(DO)
             CHGJOB     SWS(XX1XXXXX)
             GOTO       CMDLBL(MENU)
             ENDDO
/**/
/*   F12 pressed  */
/**/
             IF         COND(&IN12) THEN(DO)
             CHGJOB     SWS(XXX1XXXX)
             GOTO       CMDLBL(FIRST)
                        ENDDO
/**/
/*  No entry in field */
/**/
/*********** IF         COND(&INPUT2 *EQ '  ') THEN(DO)                /*159026*/
/**********  IF         COND((&INPUT2 *EQ '  ') *OR (&INPUT2 *EQ 'CD' + */                /*CAS006*/
/**********               *AND &CSE007 *EQ 'N')) THEN(DO)                          /*159026 CAS006*/
             IF         COND((&INPUT2 *EQ '  ') *OR (&INPUT2 *EQ 'CD' +
                          *AND &CSE007 *EQ 'N') *OR (&INPUT2 *EQ 'HG' +
                          *AND &CAS006 *EQ 'N' *OR &INPUT2 *EQ 'HG' +
                          *AND &CAS007 *EQ 'N')) THEN(DO)                                /*BUG9343*/
/***********              *AND &CAS006 *EQ 'N')) THEN(DO)             */          /*CAS006 BUG9343*/
             CHGVAR     VAR(&MSG) VALUE('Invalid option entered')
             GOTO       CMDLBL(SECOND)
             ENDDO
/**/
/*                      CHGVAR     VAR(&OVRD) VALUE('SEKEYSXX')*/
/*                      GOTO       CMDLBL(MENU)                */
/*                      ENDDO                                  */
/**/                                                                  /*S01447*/
/*  Entry in field for WT but feature not switched on                   S01447*/
/**/                                                                  /*S01447*/
             IF         COND(&IN11 *EQ '0' *AND &INPUT2 *EQ 'WT') +
                          THEN(DO)                                    /*S01447*/
             CHGVAR     VAR(&MSG) VALUE('Invalid option entered')     /*S01447*/
             GOTO       CMDLBL(SECOND)                                /*S01447*/
             ENDDO                                                    /*S01447*/
/**/                                                                  /*CAC002*/
/*  Entry in field is MA or MV but Analytical Acctg not installed */  /*CAC002*/
/**/                                                                  /*CAC002*/
             IF         COND(&INPUT2 *EQ 'MV' *AND &IN20 *EQ '0' *OR +
                          &INPUT2 *EQ 'MA' *AND &IN20 *EQ '0') +
                          THEN(DO)                                    /*CAC002*/
                CHGVAR     VAR(&MSG) VALUE('Invalid option entered')  /*CAC002*/
                GOTO       CMDLBL(SECOND)                             /*CAC002*/
             ENDDO                                                    /*CAC002*/
/**/                                                                  /*S01447*/
             CHGVAR     VAR(&OVRD) VALUE('SEKEYS' *CAT &INPUT2)
             GOTO       CMDLBL(MENU)
                                                             /*S01315*/
             ENDDO
             CHGVAR     VAR(&OVRD) VALUE('SEKEYS' *CAT &INPUT1)
             GOTO       CMDLBL(MENU)                                 /*S01447*/
/**/
EXIT:                                                                /*S01447*/
/* */                                                                /*S01447*/
/** Call AOSARDR0 with an option of '*FREE' to close the file.       /*S01447*/
             CHGVAR     VAR(&SOPTN) VALUE('*FREE')                   /*S01447*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)     /*S01447*/
             GOTO       CMDLBL(MENU)                                 /*159026*/
EXIT1:                                                               /*159026*/
/* */                                                                /*159026*/
/** Call AOSARDR0 with an option of '*FREE' to close the file.       /*159026*/
             CHGVAR     VAR(&SOPTN) VALUE('*FREE')                   /*159026*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)     /*159026*/
 MENU:       RETURN
             CHGVAR     VAR(&IN11) VALUE('0')                        /*S01447*/
             CHGVAR     VAR(&IN20) VALUE('0')                        /*CAC002*/
             CHGVAR     VAR(&IN50) VALUE('0')                        /*159026*/
             ENDPGM
