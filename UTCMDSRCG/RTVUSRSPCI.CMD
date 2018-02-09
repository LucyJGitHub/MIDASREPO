/*********************************************************************/
/*STD    CMDBASEPGM                                                  */
/*EXI    PGM(UT0250)     VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RTVUSRSPCI) HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Retrieve user space init. command')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       RTVUSRSPCI (Retreive user space initialisation) command     */
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
/*                                                                 */
/* The Retrieve User Space Initialization command does a call      */
/*   to the system provided QUSRTVUS program to return to the      */
/*   CL program the important initial values in dealing with       */
/*   a list created in a user space.                               */
/*                                                                 */
/* The CPP is UT0250.                                              */
/*                                                                 */
             CMD        PROMPT('Retrieve User Space Init.')
             PARM       KWD(USRSPC) TYPE(QUAL1) MIN(1) +
                          PROMPT('User space name')
             PARM       KWD(STRPOS) TYPE(*CHAR) LEN(4) +
                          RTNVAL(*YES) +
                          PROMPT('Start position of the list (4)')
             PARM       KWD(NBRENT) TYPE(*DEC) LEN(9 0) +
                          RTNVAL(*YES) +
                          PROMPT('Number of entries        (9 0)')
             PARM       KWD(ENTLEN) TYPE(*CHAR) LEN(4) +
                          RTNVAL(*YES) +
                          PROMPT('Entry length               (4)')
QUAL1:       QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL(*LIBL *CURLIB) +
                          PROMPT('Library name')
