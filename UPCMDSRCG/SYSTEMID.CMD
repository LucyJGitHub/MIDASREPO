/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC0007) MSGF(UTMSGF) ALLOW(*IPGM *IREXX *IMOD)         */
/*EXI    HLPPNLGRP(SYSTEMID)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP Enter a Midas system ID')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas Upgrade Module                                        */
/*                                                                   */
/*       SYSTEMID - Enter Midas system ID                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Last Amend No. CUP011 *CREATE     DATE 04Oct00              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP011 - New command to allow user to enter a Midas         */
/*                 system ID                                         */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Enter a Midas system ID')
 
             PARM       KWD(SYSID) TYPE(*NAME) LEN(2) MIN(1) +
                          PROMPT('Midas system ID' 1)
