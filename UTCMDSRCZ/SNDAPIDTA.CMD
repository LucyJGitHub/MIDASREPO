/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UT000001) MSGF(QCPFMSG)                                 */
/*EXI    HLPPNLGRP(SNDAPIDTA ) HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Send test data for the Midas APIs')          */
/*********************************************************************/
/*                                                                   */
/*     Midas - Utilities Module                                      */
/*                                                                   */
/*     SNDAPIDTA - Send API data to an MQ Series Message Queue       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*     Last Amend No. CMK002  *CREATE    Date 07Sep00                */
/*     Prev Amend No. XXXXXX             Date 00XXX00                */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*     CMK002 - Add SNDAPIDTA into core.                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Send Midas API Test Data')
 
             PARM       KWD(RETURNCODE) TYPE(*CHAR) LEN(10) +
                          CONSTANT('          ') MIN(1)
 
             PARM       KWD(SYSTEM) TYPE(*CHAR) LEN(2) MIN(1) +
                          PROMPT('Midas System Prefix')
