/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1308)    VLDCKR(RPC1308_V)  MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RPSTRCHL)   HLPID(*CMD)                             */
/*EXI *  TEXT('Midas RP PB Start Midas/TOF MQSeries Channels.')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       PBSTRCHL - Start Midas/TOF interface MQSeries channels.     */
/*                                                                   */
/*       Function: this command allows to start channels that are    */
/*                 used to move messages from AS/400 to remote queue */
/*                 managers.                                         */
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
 
             CMD        PROMPT('Start Midas/TOF Channels')
 
             PARM       KWD(QUEUEMGR) TYPE(*GENERIC) LEN(20) +
                          DFT(*ALL) SPCVAL((*ALL)) PROMPT('Queue +
                          Manager Name')
 
             PARM       KWD(CHANNEL) TYPE(*GENERIC) LEN(20) +
                          DFT(*ALL) SPCVAL((*ALL)) PROMPT('Channel +
                          Name')
 
