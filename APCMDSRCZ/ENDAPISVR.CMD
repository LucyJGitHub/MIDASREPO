/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(APCENDSVR) HLPPNLGRP(ENDAPISVR) HLPID(ENDAPISVR)        */
/*EXI *  TEXT('Midas AP End the server')                             */
/*********************************************************************/
/*                                                                   */
/*       Midas - APIs                                                */
/*                                                                   */
/*       ENDAPISVR - End the API server                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CAP002  *CREATE    Date 01May98              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CAP002 - Conversion of transaction inputs into modular      */
/*                structure to use as APIs.                          */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('End API Server')
 
             PARM       KWD(SYSTEM) TYPE(*CHAR) LEN(2) MIN(1) +
                          PROMPT('Midas system prefix')
