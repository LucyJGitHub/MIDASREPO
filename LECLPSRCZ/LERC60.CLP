/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas I/C Facility History Report Prompt')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                         */
/*                                                                   */
/*       LERC60 - Individual Facility History Report Prompt          */
/*                (Input Cycle)                                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 064705             DATE 07APR94              */
/*       PREV AMEND NO. 000004             DATE 16APR92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       064705 - Program available in I/C therefore job must be     */
/*                submitted.                                         */
/*       000004 - New program for Release 10.                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
 
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &CMD)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(1)
 
             CHGJOB     SWS(00000000)
 
/* Call LER600 to prompt for selection required.            */
 
             CALL       PGM(LER600) PARM(&RPARM &RACT &CMD)
 
/************CALL LERC61  PARM(&RSEQ &RLEV &RENT &RPARM)          */ /*064705*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
