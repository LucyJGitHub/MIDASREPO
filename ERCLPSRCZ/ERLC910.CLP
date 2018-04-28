/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas European Reporting I.C.D. report')              */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING                               */
/*                                                                  */
/*     ERLC910  -  CALL ERL910                                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*                                                                  */
/*********************************************************************/
/**/
             PGM PARM(&ERL910DA)
 
                DCL VAR(&ERL910DA) TYPE(*CHAR) LEN(92)
                OVRDBF FILE(SECTY)   TOFILE(SECTY)    SHARE(*NO)
                CALL       PGM(ERL910) PARM(&ERL910DA)
                DLTOVR     FILE(SECTY)
 
             ENDPGM
