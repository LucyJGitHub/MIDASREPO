/*********************************************************************/
/*STD    CMDBASEPGM                                                  */
/*EXI    PGM(UTC1000)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(DSPINFSCR)  HLPID(DSPINFSCR)                      */
/*EXI *  TEXT('Midas UT Display a Midas Information screen.')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       SHWINFSCR - (Show Midas Information Screen) command         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       This command allows the user to display a Midas Information */
/*       screen interactively, using the Midas Information screen    */
/*       generator program, UTC1000.                                 */
/*                                                                   */
/*       NOTE: This version of the command can only be coded into a  */
/*       CL program; it cannot be called interactively.  If you want */
/*       to execute it from a command line, use DSPINFSCR (Display   */
/*       Midas Information screen) instead.  This version returns    */
/*       the return code and reply value.  If you are using it in an */
/*       RPG program you should instead code a call to the program   */
/*       UTC1000.                                                    */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 089864 *CREATE     Date 07AUG96              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       089864 - This was created to ease this fix, but it is       */
/*                completely generic.                                */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Show a Midas Info screen')
 
             PARM       KWD(RETURNCODE) TYPE(*CHAR) LEN(10) +
                          RTNVAL(*YES) PROMPT('CL var for return +
                          code (10A)')
 
             PARM       KWD(CALLER) TYPE(*NAME) PGM(*YES) +
                          PROMPT('Calling program')
 
             PARM       KWD(MESSAGE1) TYPE(*CHAR) LEN(7) +
                          PROMPT('Message ID 1')
             PARM       KWD(MESSAGE2) TYPE(*CHAR) LEN(7) +
                          PROMPT('Message ID 2')
             PARM       KWD(MESSAGE3) TYPE(*CHAR) LEN(7) +
                          PROMPT('Message ID 3')
             PARM       KWD(MESSAGE4) TYPE(*CHAR) LEN(7) +
                          PROMPT('Message ID 4')
             PARM       KWD(MESSAGE5) TYPE(*CHAR) LEN(7) +
                          PROMPT('Message ID 5')
             PARM       KWD(MESSAGE6) TYPE(*CHAR) LEN(7) +
                          PROMPT('M7ssage ID 6')
             PARM       KWD(MESSAGE7) TYPE(*CHAR) LEN(7) +
                          PROMPT('Message ID 7')
             PARM       KWD(MESSAGE8) TYPE(*CHAR) LEN(7) +
                          PROMPT('Message ID 8')
             PARM       KWD(MESSAGE9) TYPE(*CHAR) LEN(7) +
                          PROMPT('Message ID 9')
             PARM       KWD(MESSAGE10) TYPE(*CHAR) LEN(7) +
                          PROMPT('Message ID 10')
 
             PARM       KWD(HELPIND) TYPE(*DEC) LEN(2 0) RANGE(0 99) +
                          PROMPT('Help indicator')
 
             PARM       KWD(CALLED) TYPE(*NAME) PGM(*YES) +
                          PROMPT('Program to call')
 
             PARM       KWD(OPTION) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(ENTER) VALUES(BLANK JOBLOG OPTION +
                          OPTION2 RETRY ENTER) PROMPT('Screen +
                          format to use')
 
 
             PARM       KWD(REPLY) TYPE(*CHAR) LEN(1) RTNVAL(*YES) +
                          PROMPT('CL var for reply value (1A)')
