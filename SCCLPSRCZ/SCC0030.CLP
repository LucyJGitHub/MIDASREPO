/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Remove "MIDAS" from MSTATUS')                */
/*********************************************************************/
/*                                                                   */
/*                Midas STANDING DATA MODULE                         */
/*                                                                   */
/*         SCC0030 - AMENDMENT FOR SECURITY PROFILE FACILITY         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK017             Date 28Oct03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01343             Date 15Aug91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK017  -  Midas Plus packaging.                            */
/*                  Comment out the remove of msg from MSTATUS.      */
/*       S01343  -  SC/RR/SD MODULE RENAME PROJECT.                  */
/*                  - RENAMED FROM L1MNUA                            */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/**REMOVE*'MIDAS'*FROM*MSTATUS,*ANOTHER*WILL*BE*SENT*BY*MIPGM*/ /*                     */ /*CPK017*/
/************RCVMSG     MSGQ(MSTATUS) RMV(*YES)                                        */ /*CPK017*/
             RRTJOB     RTGDTA(MIDASIC)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
