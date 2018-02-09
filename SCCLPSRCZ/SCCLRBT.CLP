/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Clear BTS business trans. daily f')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                       */
/*                                                                   */
/*       Business Transaction Statistics Switchable Feature          */
/*                                                                   */
/*       SCCLRBT  - CLEAR BUSINESS TRANSACTION DAILY FILES           */
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
/*       Prev Amend No. S01411             Date 26Apr93              */
/*                                         Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01411 - New program for BTS                                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/* */
             DCL        &MSG          TYPE(*CHAR)  LEN(75)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
             CHGVAR     VAR(&MSG) VALUE('Clear Business Transactions +
                          Daily Files')
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)
/* */
             CLRPFM     FILE(SDBTDMPD)
             CLRPFM     FILE(SDBTFFPD)
             CLRPFM     FILE(SDBTFRPD)
             CLRPFM     FILE(SDBTFXPD)
             CLRPFM     FILE(SDBTF1PD)
             CLRPFM     FILE(SDBTF2PD)
             CLRPFM     FILE(SDBTF3PD)
             CLRPFM     FILE(SDBTF4PD)
             CLRPFM     FILE(SDBTF5PD)
             CLRPFM     FILE(SDBTF6PD)
             CLRPFM     FILE(SDBTF7PD)
             CLRPFM     FILE(SDBTGLPD)
             CLRPFM     FILE(SDBTLEPD)
             CLRPFM     FILE(SDBTMMPD)
             CLRPFM     FILE(SDBTNPPD)
             CLRPFM     FILE(SDBTNSPD)
             CLRPFM     FILE(SDBTSEPD)
/* */
             CHGVAR     VAR(&MSG) VALUE('Business Transactions Daily +
                          Files Cleared')
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)
 
/* */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
