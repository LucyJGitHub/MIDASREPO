/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Override Messages files for Disp Cust Grp')  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0635  - OVERRIDES MESSAGES FILES AND CALLS PM0635        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      S01486             Date 07Jul94              */
/*                      038430             DATE 02AUG93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       S01486 - Portfolio Management Incorporation                 */
/*  CREATED FOR 038430  CHANGES TO CUSTOMER INSERTION/DELETION PROCG */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*********** DCL        VAR(&WWMULT) TYPE(*CHAR) LEN(2)                 S01486*/
/*********** DCL        VAR(&WWMSGF) TYPE(*CHAR) LEN(10)                S01486*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
 
/*********** SETATNPGM  PGM(SDC2330)                                    S01486*/
 
/**********  STRCMTCTL  LCKLVL(*CHG)                                  /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
             MONMSG     CPF8351
/**/
/* OVERRIDE FILES TO DELETED FILES */
/*           OVRDBF     FILE(PMPORTPP) TOFILE(PMPORDPP)                 S01486*/
             OVRDBF     FILE(PMPORTPP) TOFILE(PMPORDPD)               /*S01486*/
             OVRDBF     FILE(SDPLCSPD) TOFILE(SDPCSDPD)
             OVRDBF     FILE(SDPLCSL2) TOFILE(SDPCSDL2)
/**/
/****RETRIEVE*USER*LANGUAGE*FROM*DTAARA/*LDA */                       /*S01486*/
/**/
/*********** RTVDTAARA  DTAARA(*LDA (530 2)) RTNVAR(&WWMULT)          /*S01486*/
/*********** IF         COND(&WWMULT *EQ '  ') THEN(DO)               /*S01486*/
/************* CHGVAR     VAR(&WWMULT) VALUE('GB')                    /*S01486*/
/*********** ENDDO                                                    /*S01486*/
/**/
/****OVERRIDE*MESSAGES*FILES*USING*USER*LANGUAGE */                   /*S01486*/
/**/
/*********** CHGVAR     VAR(&WWMSGF) VALUE(&WWMULT *CAT 'PMUSRMSG')     S01486*/
/*********** OVRMSGF    MSGF(PMUSRMSG) TOMSGF(&WWMSGF)                  S01486*/
/*********** CHGVAR     VAR(&WWMSGF) VALUE('"          "')              S01486*/
/*********** CHGVAR     VAR(&WWMSGF) VALUE(&WWMULT *CAT 'LBUSRMSG')     S01486*/
/*********** OVRMSGF    MSGF(LBUSRMSG) TOMSGF(&WWMSGF)                  S01486*/
/*********** CHGVAR     VAR(&WWMSGF) VALUE('"          "')              S01486*/
/*********** CHGVAR     VAR(&WWMSGF) VALUE('ML' *CAT &WWMULT  *CAT +
                          'MSGF')                                       S01486*/
/*********** OVRMSGF    MSGF(MLGBMSGF) TOMSGF(&WWMSGF)                  S01486*/
/*********** CHGVAR     VAR(&WWMSGF) VALUE('ZZ' *CAT &WWMULT  *CAT +
                          'MSGF')                                       S01486*/
/*********** OVRMSGF    MSGF(ZZGBMSGF) TOMSGF(&WWMSGF)                  S01486*/
/**/
/** RECEIVE NAME OF USER CURRENTLY SIGNED ON  */
             RTVJOBA    USER(&USER)
/**/
/**  CALL PROGRAM RPG/PM0635 */
/**/
             CALL       PGM(PM0635) PARM(&USER)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
