/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE LARGE PAYMENTS TODAY')                       */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Customer Lending Module                    */
/*                                                                   */
/*       LEC0708 -LARGE PAYMENTS TODAY                               */
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
/*       Prev Amend No. E46196             Date 24Nov92              */
/*                      S01194             Date 11Dec89              */
/*                      S01117             DATE 11DEC89              */
/*                                                                   */
/*********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       E46196 - LE0560 should be called with RCF parameters        */
/*       S01194 - NEW STANDING DATA                                  */
/*       S01117 - REL.10 MULTIBRANCHING                              */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                     * *S01117*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('LARGE PAYMENTS TODAY ')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/*PRINT                                                             */
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)             */    /*S01194*/
/*********** OVRDBF     FILE(TABLED) TOFILE(TABLEEE) SHARE(*NO) */    /*S01194*/
/**/
/************CALL       PGM(LE0560)                               */ /*E46196*/
             CALL       PGM(LE0560) PARM(&RSEQ)                      /*E46196*/
/**/
/************DLTOVR     FILE(*ALL)                             */     /*S01194*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
