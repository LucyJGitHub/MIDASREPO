/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(CB0500)     VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(BYPASS)     HLPID(*CMD)                           */
/*EXI *  TEXT('Midas CB Bypass a failed COB component')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Close of Business Module                        */
/*                                                                   */
/*       BYPASS - Bypass a Failed COB Component.                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01517             DATE 04AUG94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01517 - New command created to aid technicians.            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Bypass a Failed COB Component')
 
             PARM       KWD(COMP) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Component Name:')
 
             PARM       KWD(SEQ) TYPE(*CHAR) LEN(5) MIN(1) +
                          CHOICE('00001, 10001...') +
                          PROMPT('Component Sequence:')
