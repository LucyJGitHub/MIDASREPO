/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(MS8030P)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(WRKCASIF)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas MS Work with CAS interface')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas SWIFT Direct Link : Midas/CAS interface               */
/*                                                                   */
/*       WRKCASIF - Work with Common Application Server interface    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*    This source is centrally supported and must ONLY be            */
/*    amended by Core Development Personnel                          */
/*                                                                   */
/*    /COPY, Client or Country amendments must not be                */
/*    applied to this source.                                        */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CSW008 *CREATE     Date 15AUG96              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*       CSW008 - Midas/CAS interface                                */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Work with CAS interface')
 
             PARM       KWD(OPERATION) TYPE(*CHAR) LEN(9) RSTD(*YES) +
                          VALUES(*STARTUP *SHUTDOWN) MIN(1) +
                          PROMPT('Operation')
 
             PARM       KWD(L_MAPID) TYPE(*CHAR) LEN(26) RSTD(*NO) +
                          DFT(*ALL) SPCVAL((*ALL)) MIN(0) +
                          CASE(*MIXED) PROMPT('L-mapid')
 
             PARM       KWD(MODE) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          DFT(*MANUAL) VALUES(*AUTO *MANUAL) MIN(0) +
                          PMTCTL(PMT1) PROMPT('Mode')
 
             PARM       KWD(TYPE) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          DFT(*SYNCH) VALUES(*SYNCH *ASYNCH) MIN(0) +
                          PMTCTL(PMT2) PROMPT('Type')
 
 PMT1:       PMTCTL     CTL(OPERATION) COND((*EQ *STARTUP))
 
 PMT2:       PMTCTL     CTL(OPERATION) COND((*EQ *SHUTDOWN))
