/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1317)    VLDCKR(RPC1317_V)  MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RPDSPMSGF)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas RP PB Display additional Message formats mbr')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPDSPMSGF - Display additional message formats member.      */
/*                                                                   */
/*       Function: this command displays physical database file      */
/*                 member from file RPMSGFPD that contains all       */
/*                 Additional Replication processing message formats */
/*                 for specific interface.                           */
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
 
             CMD        PROMPT('Display addit. message formats')
 
             PARM       KWD(INTERFACE) TYPE(*NAME) LEN(10) RSTD(*NO) +
                          MIN(1) MAX(1) CHOICE(*PGM) +
                          CHOICEPGM(RPC1317_E) PROMPT('Interface Name')
