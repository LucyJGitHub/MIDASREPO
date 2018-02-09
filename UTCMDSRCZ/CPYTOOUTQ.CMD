/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0200)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(CPYTOOUTQ)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Copy to output queue command')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       CPYTOOUTQ (Copy to output queue) command                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAA002 *CREATE     Date 31OCT95              */
/*                      nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAA002 - Development of utility to save, edit and restore   */
/*                spooled files.                                     */
/*                                                                   */
/*********************************************************************/
/*                                                                  */
/* The Copy To Output Queue command takes the data base file        */
/*   created by CPYFRMOUTQ and prints them to an output queue.      */
/*                                                                  */
/* The CPP is UTC0200.                                              */
/*                                                                  */
             CMD        PROMPT('Copy to OUTQ')
             PARM       KWD(DBFILE) TYPE(QUAL1) MIN(1) +
                          PROMPT('Data base file')
             PARM       KWD(OUTQ) TYPE(QUAL2) MIN(1) +
                          PROMPT('Output queue')
             PARM       KWD(PRTFILE) TYPE(QUAL3) +
                          PROMPT('Printer file')
             PARM       KWD(MBR) TYPE(*NAME) LEN(10) DFT(*ALL) +
                          EXPR(*YES) SPCVAL(*ALL) +
                          PROMPT('Member')
             PARM       KWD(PRTWIDTH) TYPE(*DEC) LEN(3 0) DFT(*PRTF) +
                          SPCVAL((*PRTF 0)) +
                          RANGE(20 210) +
                          PROMPT('Print record width')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) EXPR(*YES)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL(*LIBL) +
                          EXPR(*YES) PROMPT('Library name')
 QUAL2:      QUAL       TYPE(*NAME) LEN(10) EXPR(*YES)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) SPCVAL(*LIBL) +
                          EXPR(*YES) PROMPT('Library name')
 QUAL3:      QUAL       TYPE(*NAME) LEN(10) EXPR(*YES) DFT(QSYSPRT)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) SPCVAL(*LIBL) +
                          EXPR(*YES) PROMPT('Library name')
