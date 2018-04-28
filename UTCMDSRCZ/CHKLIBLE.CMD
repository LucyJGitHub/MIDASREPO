/*********************************************************************/
/*STD    CMDBASEPGM                                                  */
/*EXI    PGM(UTC0065)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(CHKLIBLE)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Check if no. of library additions allowed')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utitlities Module                                   */
/*                                                                   */
/*       CHKLIBLE - Check that addition of libraries is allowed      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC017             Date 14Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP001 *CREATE     Date 21Dec98              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC017 - Change to 250 library list.                        */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Check library list entries')
 
/************PARM       KWD(NOOFLIBS) TYPE(*DEC) LEN(2) DFT(0) +                       */ /*CSC017*/
/************             RANGE(0 25) PROMPT('No. of libraries to +                    */ /*CSC017*/
/************             be added')                                                   */ /*CSC017*/
             PARM       KWD(NOOFLIBS) TYPE(*DEC) LEN(3) DFT(0) +
                          RANGE(0 250) PROMPT('No. of libraries to +
                          be added')                                                      /*CSC017*/
 
/************PARM       KWD(LIBS) TYPE(*CHAR) LEN(10) MAX(25) +                        */ /*CSC017*/
/************             PROMPT('Libraries required to be added')                     */ /*CSC017*/
             PARM       KWD(LIBS) TYPE(*CHAR) LEN(10) MAX(250) +
                          PROMPT('Libraries required to be added')                        /*CSC017*/
 
             PARM       KWD(RETURN) TYPE(*CHAR) LEN(1) RTNVAL(*YES) +
                          PROMPT('Return value')
