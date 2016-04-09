/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(BALCHK)     VLDCKR(*NONE)     MSGF(QCPFMSG)             */
/*EXI    HLPPNLGRP(BALCHK)     HLPID(*CMD)                           */
/*EXI *  TEXT('Midas GL Statement & ledger balance reconciliation')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       BALCHK - STATEMENT AND LEDGER BALANCE RECONCILIATION RPT    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 095892             DATE 23NOV95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       095892 - Incorporation of BALCHK utility into core          */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Statement and Ledger Bal. Rec.')
 
             PARM       KWD(UPDATE) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(N Y) MIN(0) PROMPT('Update +
                          Account Master File')
 
