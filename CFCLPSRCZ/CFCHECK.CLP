/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF Control program for CFC0180 activity')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - CONFIRMATION MATCHING                       */
/*                                                                   */
/*       CFCHECK - CONTROL PGM FOR TESTING CFC0180 ACTIVITY          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E35594            DATE 06FEB92               */
/*       PREV AMEND NO. S01304            DATE 20SEP90               */
/*                                                                   */
/*********************************************************************/
/*       E35594 - PROGRAM RE-DELIVERED TO COLLECTIONS AFTER          */
/*                REINSTATEMENT.                                     */
/*       S01304 - PROGRAM CREATED FOR CONFIRMATION MATCHING          */
/*********************************************************************/
             PGM
 
             DCL        VAR(&SPLFST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SBS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&SBS)   VALUE('M' *CAT &PREFIX *CAT 'SBS')
 
 
/**  CHECK IF CFCONTROL ACTIVE */
 
             DLTDTAARA  DTAARA(QTEMP/SPLFST)
             MONMSG     MSGID(CPF0000)
 
             CRTDTAARA  DTAARA(QTEMP/SPLFST) TYPE(*CHAR) LEN(1) +
                          VALUE('N')
             MONMSG     MSGID(CPF0000)
             CRTPF FILE(QTEMP/SPLF) RCDLEN(133)
             MONMSG     MSGID(CPF0000)
 
             WRKSBSJOB  SBS(&SBS) OUTPUT(*PRINT)
 
             CPYSPLF    FILE(QPDSPSBJ) TOFILE(QTEMP/SPLF) SPLNBR(*LAST)
 
             CALL      CFTEST
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
