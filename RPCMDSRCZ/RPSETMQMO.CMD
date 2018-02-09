/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1306)    VLDCKR(RPC1306_V)  MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RPSETMQMO)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas RP PB Define queues and channels.')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPSETMQMO - Define MQM queues and channels.                 */
/*                                                                   */
/*       Function: this command allows to define MQM queues and      */
/*                 channels needed to receive messages from PC and   */
/*                 to send reply messages to PC.                     */
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
/*       Prev Amend No. CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Define MQM queues and channels')
 
             PARM       KWD(PC_ID) TYPE(*GENERIC) LEN(4) +
                          SPCVAL((*ALL)) MIN(1) PROMPT('PC Id.')
             PARM       KWD(REPLACE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PROMPT('Replace')
