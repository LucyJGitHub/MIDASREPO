/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Customer Selection Screen')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC5018 - STARTING UP GROUP JOB 'POOL PORTFOLIO'            */
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
/*       Prev Amend No. S01486             Date 23Aug94              */
/*                      063365             Date 16Nov93              */
/*                      SA9108             DATE 20OCT93              */
/*                      049421             DATE 18JAN93              */
/*                      SA9108             DATE 18JAN93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       063365  -  ERROR ON POOL PORTFOLIO POSITION                 */
/*       SA9108  -  POOL TRANSACTIONS SAR                            */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       SA9108  -  WRITTEN FOR POOL SECURITIES                      */
/*                                                                   */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&LIB) TYPE(*CHAR) LEN(2)          *SA9108* *S01486*/
/************DCL        VAR(&PMR) TYPE(*CHAR) LEN(1)          *SA9108* *S01486*/
 
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIB)     *SA9108* *S01486*/
/*>>> 063365 >>> */
/*********** RTVDTAARA  DTAARA((&LIB *CAT 'DMLIB')/LZSTAT (33 1)) +
                          RTNVAR(&PMR)                        /*SA9108 063365 */
/************RTVDTAARA  DTAARA((&LIB *CAT 'DMLIB')/LZSTAT (35 1)) +    *S01486*/
/************             RTNVAR(&PMR)                        *063365* *S01486*/
/*<<< 063365 <<< */
 
/************IF         COND(&PMR *NE 'Y') THEN(DO)           *SA9108* *S01486*/
/************SNDPGMMSG  MSG('Pool Portfolios not installed - Option +  *S01486*/
/************             not allowed') TOPGMQ(*EXT)          *SA9108* *S01486*/
/************GOTO       CMDLBL(ENDPGM)                        *SA9108* *S01486*/
/************ENDDO                                            *SA9108* *S01486*/
 
/************CHGGRPA    GRPJOB(CUSTOMER) TEXT('Group job for +         *S01486*/
/************             customer choice')                            *S01486*/
/************OVRDBF     FILE(PMCSNPXX) TOFILE(PMCSNPPP) SHARE(*NO)     *S01486*/
/************OVRDBF     FILE(PMPTNPXX) TOFILE(PMPTNPPP) SHARE(*NO)     *S01486*/
             OVRDBF     FILE(PMCSNPXX) TOFILE(PMCSNPPD) SHARE(*NO)    /*S01486*/
             OVRDBF     FILE(PMPTNPXX) TOFILE(PMPTNPPD) SHARE(*NO)    /*S01486*/
             RTVJOBA    USER(&USER)
 
             CALL       PGM(PM5018) PARM(&USER)
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Program PMC5018 ended abnormally - job +
                          cancelled') TOMSGQ(MOPERQ)
             ENDDO
/************CHGGRPA    GRPJOB(*NONE)                                 /*S01486*/
 
/***********ENDPGM:        ENDPGM                                      *S01486*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
