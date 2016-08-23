/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Abbrev. Journ ents Ovrdbf Share(*no)')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - General Ledger Module                     */
/*                                                                  */
/*      GLC1410  - ABREVIATED JOURNAL ENTERIES                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 14AUG96             */
/*       PREV AMEND NO. CAC001             DATE 01FEB96             */
/*                      S01251             DATE 03FEB90             */
/*                      S01168             DATE 14/11/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       S01408  -  Core Hook GLC1410001 Added                     */
/*               -  Core Hook GLC1410MPS Added                     */
/*       CAC001  -  Profit Centre Accounting Development:           */
/*                  Do not allow use if Analytical Accounting       */
/*                  module is present.                              */
/*       S01251  -  SYNON FIELD/PROGRAM NAME CHANGES                */
/*       S01168  -  GL SYNON                                        */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(128)               /*CAC001*/
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)              /*CAC001*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*CAC001*/
/*/COPY WNCPYSRC,GLC1410002                                          */
/**/                                                                  /*CAC001*/
             CALL       PGM(AOMMODR0) PARM('*DBERR' '*FIRST' &MMOD)   /*CAC001*/
/**/                                                                  /*CAC001*/
/**  If Analytical Accounting is present, user will not be allowed */ /*CAC001*/
/**  to use the Abbreviated Journal Entries function               */ /*CAC001*/
/**/                                                                  /*CAC001*/
             IF         COND(%SST(&MMOD 100 1) *EQ 'Y') THEN(DO)      /*CAC001*/
                RTVMSG     MSGID(GLM0001) MSGF(GBMIDASMSG) +
                             MSG(&MESSAGE)                            /*CAC001*/
                CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)  /*CAC001*/
                RTVMSG     MSGID(GLM0002) MSGF(GBMIDASMSG) +
                             MSG(&MESSAGE)                            /*CAC001*/
                CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MESSAGE)  /*CAC001*/
                CALL       PGM(SCC0010) PARM('GLC1410' 'ENTER' +
                             &NOREPLY)                                /*CAC001*/
                GOTO       CMDLBL(ENDPGM)                             /*CAC001*/
             ENDDO                                                    /*CAC001*/
/**/                                                                  /*CAC001*/
/**********  OVRDBF     FILE(GLBRREL0) SHARE(*NO)                  */ /*S01251*/
             OVRDBF     FILE(GLJENHL0) SHARE(*NO)                     /*S01251*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC1410MPS                                   */      /*S01408*/
/**/                                                                  /*S01408*/
 
/**********  CALL       PGM(GLCWDFR) PARM(' ')                     */ /*S01251*/
             CALL       PGM(GL0101D) PARM(' ')                        /*S01251*/
 
/**********  DLTOVR     FILE(GLBRREL0)                             */ /*S01251*/
             DLTOVR     FILE(GLJENHL0)                                /*S01251*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC1410001                                   */      /*S01408*/
/**/                                                                  /*S01408*/
 
ENDPGM:                                                               /*CAC001*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
