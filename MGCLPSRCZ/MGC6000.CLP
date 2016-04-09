/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MG Access workstation id for I/C p/r')          */
/*********************************************************************/
/*                                                                   */
/*     Midas - MESSAGE GENERATION                            */
/*                                                                   */
/*     MGC6000 - Dummy prompt program to acces submitting job's      */
/*               workstation id for I/C pay/receives.                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. X00000             DATE 00XXX00              */
/*       PREV AMEND NO. X00000             DATE 00XXX00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM        PARM(&SEQ &LVL &ENT &PRM &ACT &CMD)
 
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&WID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Access workstation id */
             RTVJOBA    JOB(&WID)
 
/* Move workstation id to 100 long RCF parameter */
             CHGVAR     VAR(%SUBSTRING(&PRM 1 10)) VALUE(&WID)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
