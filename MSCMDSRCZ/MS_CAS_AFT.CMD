/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(MSC3400)    VLDCKR(*NONE)      MSGF(GBMIDAS)            */
/*EXI    HLPPNLGRP(MS_CAS_AFT) HLPID(*CMD)                           */
/*EXI *  TEXT('Midas MS switch from CAS to AFT and back')            */
/*********************************************************************/
/*                                                                   */
/*       Midas SWIFT Direct Link                                     */
/*                                                                   */
/*       MS_CAS_AFT Switch from CAS interface to AFT and back        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CSW009 *CREATE     Date 25JUL97              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*       CSW009 - Midas-SWIFT Alliance Automated File Transfer       */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Switch CAS <--> AFT interface')
 
             PARM       KWD(OPERATION) TYPE(*CHAR) LEN(11) +
                          RSTD(*YES) VALUES(*CAS_TO_AFT +
                          *AFT_TO_CAS) MIN(1) PROMPT('Operation')
 
             PARM       KWD(SURE) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Are you sure?')
 
             DEP        CTL(*ALWAYS) PARM((&SURE *EQ 'Y')) +
                          MSGID(MEM7005)
