/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC2090)    VLDCKR(*NONE)      MSGF(UTMSGF)             */
/*EXI    HLPPNLGRP(MRGMSGFS)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP Merge all message files from prompted lib')  */
/*********************************************************************/
/*                                                                   */
/*       Midas Upgrade Module                                        */
/*                                                                   */
/*       MRGMSGFS - Merge all message files from prompted library    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP001 *CREATE     DATE 11Sep98              */
/*                      Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Merge all message files')
 
             PARM       KWD(LIB) TYPE(*CHAR) LEN(10) MIN(0) +
                          PROMPT('Library containing msg. files' 1)
 
