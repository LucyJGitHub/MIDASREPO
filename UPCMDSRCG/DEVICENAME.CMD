/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC0009) MSGF(UTMSGF) ALLOW(*IPGM *IREXX *IMOD)         */
/*EXI    HLPPNLGRP(DEVICENAME) HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP Enter a device name')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas Upgrade Module                                        */
/*                                                                   */
/*       DEVICENAME - Enter a device name                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CUP016 *CREATE     Date 28Dec01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP016 - Reelease 4 enhancements.                           */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Enter a device name')
 
             PARM       KWD(DEVD) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Device name' 1)
