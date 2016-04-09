/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Rtrv portfolio proc. licensed ind')          */
/********************************************************************/
/*                                                                  */
/*         Midas       Standing Data Module                     */
/*                                                                  */
/*       SDC0521U- RETRIEVE PORTFOLIO LICENSING                     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*******************************************************************/
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*          LAST AMEND NO. S01117         DATE  10SEP91              */
/*          PREV AMEND NO. S01251         Date  21/02/90             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*          S01117 - MULTIBRANCHING                                  */
/*          S01251 - This source re-delivered for field name changes */
/*                   (no amendments required).                       */
/*                                                                   */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PFPL)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&PFPL) TYPE(*CHAR) LEN(1)
             RTVDTAARA  DTAARA(SESTAT (64 1)) RTNVAR(&PFPL)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
