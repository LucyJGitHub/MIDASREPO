/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1316)    VLDCKR(RPC1316_V)  MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RPDSPSCRPT)  HLPID(*CMD)                          */
/*EXI *  TEXT('Midas RP PB Display System Replication Definitions')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPDSPSCRPT - Display System Replication Definitions.        */
/*                                                                   */
/*       Function: this command displays source file member from     */
/*                 source file MDBASCRIPT that contains all filters  */
/*                 relating to specific remote system.               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CPB002  *CREATE    Date 20Jul00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Display Replication Script.')
 
             PARM       KWD(SYSTEMNAME) TYPE(*NAME) LEN(10) +
                          RSTD(*NO) MIN(1) MAX(1) CHOICE(*PGM) +
                          CHOICEPGM(RP1316_E) PROMPT('System name')
