/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE LOANS/PARTS INPUT TODAY')                    */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0601B - LOANS/PARTICIPATIONS INPUT TODAY                */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD020242           Date 30Sep13              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01194 *CREATE    Date  08Feb90              */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       MD020242 - Daily clear of PF/LELSUTPD file when CLE055 is  */
/*                  present                                         */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                          VALUE('LOANS/PARTICIPATIONS INPUT +
                          TODAY REPORT')
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                               /*MD020242*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                   /*MD020242*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                            VALUE('*VERIFY')                                            /*MD020242*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                   /*MD020242*/
             DCL        VAR(&CLE055) TYPE(*CHAR) LEN(1)                                 /*MD020242*/
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
                                                                                        /*MD020242*/
/**  Check if CLE055 is enabled */                                                      /*MD020242*/
                                                                                        /*MD020242*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                     /*MD020242*/
             CHGVAR     VAR(&SARD) VALUE('CLE055')                                      /*MD020242*/
                                                                                        /*MD020242*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                   /*MD020242*/
                                                                                        /*MD020242*/
             CHGVAR     VAR(&CLE055) VALUE('N')                                         /*MD020242*/
             IF         COND(&RTCD *EQ '       ') +
                        THEN(CHGVAR VAR(&CLE055) VALUE('Y'))                            /*MD020242*/
             IF         COND(&CLE055 *EQ 'Y') THEN(CLRPFM +
                          FILE(LELSUTPD))                                               /*MD020242*/
/**/
             OVRDBF     FILE(CLONT) TOFILE(CLOAN) SHARE(*NO)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
/**/
             CALL       PGM(LE0310)
/**/
             DLTOVR     FILE(*ALL)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
