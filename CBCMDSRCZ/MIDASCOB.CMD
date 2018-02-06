/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(CBC000560)  VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(MIDASCOB)     HLPID(*CMD)                         */
/*EXI *  TEXT('Midas CB Start or re-enter a zone COB')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Module                            */
/*                                                                   */
/*       MIDASCOB - Start or Re-enter a Zone COB                     */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018  *CREATE    Date 19Apr04              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - Simplify the starting and re-entering of a COB.    */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Start or Re-enter a Zone COB')
 
             PARM       KWD(SYSTEM) TYPE(*CHAR) LEN(2) MIN(1) +
                          PROMPT('Midas System Prefix')
