/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC0090A)   VLDCKR(UPC0091A)   MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(UPDDLVLST)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP Update deliverables list')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPDDLVLST - Update Deliverables List                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP001 *CREATE     Date 15Jul98              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Update Deliverables List')
 
             PARM       KWD(DLVLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Deliverables library')
 
