/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC0006) MSGF(UTMSGF) ALLOW(*IPGM *IREXX *IMOD)         */
/*EXI    HLPPNLGRP(USERNAME)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP Enter an User Name and Description')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       USERNAME - Enter User Name and Description                  */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.03 --------------------------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. CSM002 *CREATE     DATE 30Oct02              */
/*                      xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSM002 - Allow rename of old users and description in       */
/*                migration.                                         */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Enter User Name and Text')
 
/************PARM       KWD(USERNAME) TYPE(*NAME) LEN(10) MIN(1) +                     */ /*CUP016*/
/************             PROMPT('User Name' 1)                                        */ /*CUP016*/
             PARM       KWD(USERNAME) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('User Name' 1)                                           /*CUP016*/
             PARM       KWD(USERTEXT) TYPE(*CHAR) LEN(25) MIN(0) +
                          CASE(*MIXED) PROMPT('User Name +
                          Description' 2)
