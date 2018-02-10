/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Call MEC0846 via RCF')                          */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC0846R - ISO Mail / Single message print - Call via RCF  */
/*                                                                  */
/*       Call FC0400X with parameters for ME0846                    */
/*                                                                  */
/*      (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO.  X00000           DATE 00XXX00              */
/*                       X00000           DATE 00XXX00              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/********************************************************************/
 
             PGM        PARM(&TRN &BRANCH &MBIN)
 
/* Copyright in object */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Parameters */
             DCL        VAR(&TRN) TYPE(*CHAR) LEN(16)   /* TRN       */
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)   /* MBIN      */
             DCL        VAR(&BRANCH) TYPE(*CHAR) LEN(3) /* BRANCH    */
 
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
 
             CHGVAR     VAR(%SST(&RPARM 1 16)) VALUE(&TRN)
 
             CALL       PGM(FC0040X) PARM(' ' 'ME0846' 'MEC0846' +
                          '10001' &RPARM &MBIN 'B' &BRANCH)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
