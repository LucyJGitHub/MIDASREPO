/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Retrieve and pass back UPBS')                */
/********************************************************************/
/*                                                                  */
/*       Midas     SECURITIES TRADING RELEASE 2 MODULE              */
/*                                                                  */
/*       SECTAB36  RETRIEVE UNREALISED PROFIT BASIS FOR             */
/*                 OTHER CL PROGRAMS.                               */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*      PREV AMEND NO. S01117             DATE  08AUG91             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*      MD046248 - Finastra Rebranding                              */
/*      S01117  -  MULTIBRANCHING                                   */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&UPBS &RPBS)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCLF       FILE(TABTB36  )
 
             RCVF
 
/*ENDPGM:****ENDPGM*******                                             *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
 
