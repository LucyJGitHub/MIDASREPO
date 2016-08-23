/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MQ Check for batch mode')                       */
/*********************************************************************/
/*                                                                   */
/*      Midas - Midas/Q Module                                       */
/*                                                                   */
/*      MQ541BC - Check Batch mode to determine whether to open      */
/*                display file(s) in calling interface program       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 188502             Date 28Dec01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CMQ001             Date 31Oct97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       188502 - Do not display when running during COB.            */
/*       CMQ001 - MidasQ rationalisation.                            */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&MODE)
/**/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                          */ /*188502 CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             RTVJOBA    TYPE(&MODE)
/**********  RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)                      */ /*188502 CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(CHGVAR VAR(&MODE) +           */        /*CCB020*/
/**********               VALUE('0'))                                           */ /*188502 CCB020*/
             IF         COND(&COBST *EQ '*YES') THEN(CHGVAR +
                          VAR(&MODE) VALUE('0'))                                          /*CCB020*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
