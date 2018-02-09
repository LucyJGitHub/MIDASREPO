/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas European Reporting I.C.D. report')              */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING                               */
/*                                                                  */
/*     ERLC910  -  CALL ERL910                                      */
/*                                                                  */
/*       (c) Finastra International Limited 2005                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
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
