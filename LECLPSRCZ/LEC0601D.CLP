/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE ADJ. TO ACCRUED INT & COMM FEES')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0601D - ADJUSTMENTS TO ACC. INT. & COMMITMENT FEES      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CLE106            Date  01Aug04             */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. BH3489            DATE  28AUG92             */
/*                      S01194            DATE  08FEB90             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CLE106 - Syndication Manager. LE0332 is no longer required */
/*                as Manual Adjustments don't need to be extracted  */
/*                but are stored in LEADINPD instead.               */
/*       BH3489 - No longer require commitment fee stuff            */
/*       S01194 - NEW STANDING DATA                                 */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                          VALUE('ADJUSTMENTS TO ACCRUED INTEREST +
                          AND COMMITMENT FEES INPUT TODAY REPORT')
             DCL        VAR(&CLE106) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CLE106*/
             DCL        VAR(&SARO) TYPE(*CHAR) LEN(6)                                     /*CLE106*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CLE106*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*CLE106*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CLE106*/
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/                                                                                      /*CLE106*/
/* Check if CLE106 is installed */                                                        /*CLE106*/
/**/                                                                                      /*CLE106*/
             CHGVAR     VAR(&SARO) VALUE('CLE106')                                        /*CLE106*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE106*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARO &FMT)                        /*CLE106*/
             IF         COND(&RTCD *EQ '       ') +
                 THEN(CHGVAR VAR(&CLE106) VALUE('Y'))                                     /*CLE106*/
             ELSE       CMD(CHGVAR VAR(&CLE106) VALUE('N'))                               /*CLE106*/
/**/
             CLRPFM     FILE(AIADJSG)
             CLRPFM     FILE(AIADJAQ)
             CLRPFM     FILE(CFADJSG)
             CLRPFM     FILE(CFADJCO)
/**/
/* EXTRACT REPORTING FILES FROM LF/STRAN */
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
               IF         COND(&CLE106 = 'N') THEN(DO)                                    /*CLE106*/
             CALL       PGM(LE0332)
               ENDDO                                                                      /*CLE106*/
/**/
/* ADJUSTMENTS TO ACCRUED INTEREST REPORT */
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
                CALL       PGM(LE0340)
/**/
             ENDDO
/**/
/* ADJUSTMENTS TO COMMITMENT FEES REPORT */
/************IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)****/       /* BH3489 */
/**/
/***************CALL       PGM(LE0350)****/                         /* BH3489 */
/**/
/************ENDDO****/                                             /* BH3489 */
/* CLEAR EXTRACT FILES */
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
                CLRPFM     FILE(AIADJSG)
                CLRPFM     FILE(AIADJAQ)
                CLRPFM     FILE(CFADJSG)
                CLRPFM     FILE(CFADJCO)
/**/
             ENDDO
/**/
/*********** DLTOVR     FILE(TABLE)                                  * *S01194*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
