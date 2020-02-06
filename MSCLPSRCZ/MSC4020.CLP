/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS Set off possible duplicate entry flag')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     S.W.I.F.T. DIRECT LINK                            */
/*                                                                   */
/*     MSC4020 - SET OFF POSSIBLE DUPLICATE ENTRY FLAG               */
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
/*        PREV AMEND NO S01179             DATE 12/09/88             */
/*                      00                 DATE 00/00/00             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*     MD046248 - Finastra Rebranding                                */
/*     S01179  -  CHANGE RCVDTAARA TO RTVDTAARA FOR AS400            */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                   */
/*     DECLARE VARIABLES AND DATA AREA                               */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*                                                                   */
             DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(256)
/*           DCLDTAARA  DTAARA(MSSTAT)                              *  *S01179*/
/*                                                                   */
/*     Amend MSSTAT Position 24 to 'N' ( P.D.E. Flag)                */
/*                                                                   */
/*           RCVDTAARA  DTAARA(MSSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(MSSTAT)  RTNVAR(&MSSTAT)               /*S01179*/
             CHGVAR     VAR(%SST(&MSSTAT 24 1)) VALUE(N)
 /**         SNDDTAARA  DTAARA(MSSTAT) **/                            /*S01179*/
             CHGDTAARA  DTAARA(MSSTAT) VALUE(&MSSTAT)                 /*S01179*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
