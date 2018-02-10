/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Retrieve Data Area *LDA')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1003  - RETRIEVE DATA AREA *LDA                          */
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
/*       Prev Amend No. CPM005             Date 01Jul96              */
/*                      CPM004             Date 07Feb96              */
/*                      081239             DATE 03FEB95              */
/*                      S01486             DATE 12JUL94              */
/*                      SA9108             DATE 21OCT93              */
/*                      049421             DATE 18JAN93              */
/*                      S01313             DATE 24AUG92              */
/*                      SA9108             DATE 24AUG92              */
/*                      R00824             DATE 20NOV90              */
/*                      R10036             DATE 20SEP90              */
/*                      R10038             DATE 10SEP90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*                PBFG/5 - INSTRUMENT ASSET/LIABILITY SPLIT          */
/*                PBFG/6 - ADDITIONAL CUSTOMER DETAILS               */
/*                PBFG/7 - NET COMMITMENT BY CURRENCY                */
/*                PBFG/8 - DISPLAY POSITIONS SPLIT BY CURRENCY       */
/*       CPM004 - Bank Portfolios                                    */
/*       081239 - R10 Private Banking Rework.                        */
/*       S01486 - Portfolio Management Incorporation                 */
/*       SA9108 - POOL SECURITIES TRANSACTIONS                       */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01313 - PORTFOLIO PERFORMANCE CHANGES                      */
/*       SA9108 - POOL SECURITIES TRANSACTIONS                       */
/*       R00824 - OUTPUT BANK POLICY CODE TO DTAARA/*LDA             */
/*       R10036 - OUTPUT USER LANGUAGE CODE TO DTAARA LDA            */
/*       R10038 - OUTPUT EXTRA CUSTOMER DETAILS TO DTAARA LDA        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&WWLDA)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* >>> S01313 >>> */
/*********** DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(544)       SA9108*/
/*********** RTVDTAARA  DTAARA(*LDA (1 544)) RTNVAR(&WWLDA)    SA9108*/
/*           DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(539)                SA9108*/
/*********** DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(540)      *SA9108* *S01486*/
/************DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(595)      *S01486* *081239*/
/************DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(605)      *081239* *CPM004*/
/************DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(608)      *CPM004* *CPM005*/
             DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(663)              /*CPM005*/
/*           RTVDTAARA  DTAARA(*LDA (1 539)) VALUE(&WWLDA)              SA9108*/
/*********** RTVDTAARA  DTAARA(*LDA (1 540)) RTNVAR(&WWLDA)   *SA9108* *S01486*/
/************RTVDTAARA  DTAARA(*LDA (1 595)) RTNVAR(&WWLDA)   *S01486* *081239*/
/************RTVDTAARA  DTAARA(*LDA (1 605)) RTNVAR(&WWLDA)   *081239* *CPM004*/
/************RTVDTAARA  DTAARA(*LDA (1 608)) RTNVAR(&WWLDA)   *CPM004* *CPM005*/
             RTVDTAARA  DTAARA(*LDA (1 663)) RTNVAR(&WWLDA)           /*CPM005*/
/* <<< S01313 <<< */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
