/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC0008) MSGF(UTMSGF) ALLOW(*IPGM *IREXX *IMOD)         */
/*EXI    HLPPNLGRP(LIBNAME)    HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP Enter a library name')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas Upgrade Module                                        */
/*                                                                   */
/*       LIBNAME - Enter a library name                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014 *CREATE     Date 19Nov01              */
/*                      xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK014 - Release 4 packaging.                               */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Enter a library name')
 
             PARM       KWD(LIBNAME) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Library name' 1)
