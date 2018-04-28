/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1314)    VLDCKR(RPC1314_V)  MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RPSTRSRV)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas RP PB Start Midas/TOF Trigger Server.')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPSTRSRV - Start Meridian Trigger Server.                   */
/*                                                                   */
/*       Function: this command allows to start a Trigger Server to  */
/*                 monitor a specific Initiation Queue.              */
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
 
             CMD        PROMPT('Start Midas/TOF Trigger Server')
 
             PARM       KWD(INITQUEUE) TYPE(*NAME) LEN(48) MIN(1) +
                          PROMPT('Initiation Queue')
 
             PARM       KWD(COMMITCTL) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('Commitment +
                          Control (N/Y)')
