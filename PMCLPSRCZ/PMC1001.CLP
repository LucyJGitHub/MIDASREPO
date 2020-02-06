/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Update Data Area *LDA')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1001  - UPDATE DATA AREA *LDA                            */
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
/*                      SA9108             DATE 02OCT91              */
/*                      049421             DATE 18JAN93              */
/*                      S01313             DATE 24AUG92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*                PBFG/5 - INSTRUMENT ASSET/LIABILITY SPLIT          */
/*                PBFG/7 - NET COMMITMENT BY CURRENCY                */
/*                PBFG/8 - DISPLAY POSITIONS SPLIT BY CURRENCY       */
/*       CPM004 - Bank Portfolios                                    */
/*       081239 - R10 Private Banking Rework                         */
/*       S01486 - Portfolio Management Incorporation                 */
/*       SA9108 - POOL SECURITIES TRANSACTIONS.                      */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01313 - REWRITTEN FOR PORTFOLIO PERFROMANCE                */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&WWLDA)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*           DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(539)                SA9108*/
/*********** DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(540)      *SA9108* *S01486*/
/************DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(595)      *S01486* *081239*/
/************DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(605)      *081239* *CPM004*/
/************DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(608)      *CPM004* *CPM005*/
             DCL        VAR(&WWLDA) TYPE(*CHAR) LEN(663)              /*CPM005*/
/*           CHGDTAARA  DTAARA(*LDA (1 539)) VALUE(&WWLDA)              SA9108*/
/*********** CHGDTAARA  DTAARA(*LDA (1 540)) VALUE(&WWLDA)    *SA9108* *S01486*/
/************CHGDTAARA  DTAARA(*LDA (1 595)) VALUE(&WWLDA)    *S01486* *081239*/
/************CHGDTAARA  DTAARA(*LDA (1 605)) VALUE(&WWLDA)    *081239* *CPM004*/
/************CHGDTAARA  DTAARA(*LDA (1 608)) VALUE(&WWLDA)    *CPM004* *CPM005*/
             CHGDTAARA  DTAARA(*LDA (1 663)) VALUE(&WWLDA)            /*CPM005*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
