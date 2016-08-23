/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(CG0001)                                                 */
/*EXI *  TEXT('Midas CG Correspondent migration command')            */
/*********************************************************************/
/*                                                                   */
/*  Midas - User Defined Correspondence                              */
/*                                                                   */
/*  CGMIGRATE - Prompt correspondent database migration              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO. S01522             DATE 14JLY95                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01522 - Created for User Defined Correspondence            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Migrate correspondent data')
 
             PARM       KWD(CUSTOMER) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('Migrate +
                          customer details')
             PARM       KWD(ALTERNATE) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('Migrate alt. +
                          name and address')
             PARM       KWD(NOSTRO) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('Migrate +
                          counterparty nostros')
             PARM       KWD(SCHEDULE) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Create +
                          schedule entries')
 
             PARM       KWD(CUSTPFX) TYPE(*CHAR) LEN(2) RSTD(*NO) +
                          PROMPT('Prefix for customers')
             PARM       KWD(NOSTROPFX) TYPE(*CHAR) LEN(2) RSTD(*NO) +
                          PROMPT('Prefix for c/p nostros')
