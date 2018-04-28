/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1302)    VLDCKR(RPC1302_V)  MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RPENDSRV)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas RP PB Stop Midas/TOF Trigger Server.')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPENDSRV - Stop Meridian Trigger Server.                    */
/*                                                                   */
/*       Function: this command stops the trigger server program     */
/*                 that is monitoring the Initiation Queue.          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Stop Meridian Trigger Server')
 
             PARM       KWD(INITQUEUE) TYPE(*NAME) LEN(48) MIN(1) +
                          PROMPT('Initiation Queue')
