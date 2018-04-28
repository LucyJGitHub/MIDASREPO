/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(MSC8040)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(WRKCASTRC)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas MS Work with CAS trace')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas SWIFT Direct Link : Midas/CAS interface               */
/*                                                                   */
/*       WRKCASTRC - Work with Common Application Server trace       */
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
/*       Last Amend No. CSW008 *CREATE     Date 11NOV96              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*       CSW008 - Midas/CAS interface                                */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Work with CAS trace')
 
             PARM       KWD(OPERATION) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          VALUES(*TOGGLE *CHECK) MIN(1) +
                          PROMPT('Operation')
 
