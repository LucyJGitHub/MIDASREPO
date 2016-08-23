/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1311)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RPTRGSRV)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas RP PB Run Midas/TOF MQSeries Trigger Server.')  */
/*ADD    CHGCMD CMD(RPTRGSRV)  ALLOW(*BPGM *BATCH)                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPTRGSRV - Run Midas/TOF interface Trigger Server.          */
/*                                                                   */
/*       Function: this command allows to ensure that parameters     */
/*                 are passed to the trigger Server program as       */
/*                 expected, without being truncated as it could     */
/*                 happen with character variables longer than 32    */
/*                 characters (case of Initiation Queue).            */
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
 
             CMD        PROMPT('Run Midas/TOF Trigger Server')
 
             PARM       KWD(INITQUEUE) TYPE(*NAME) LEN(48) MIN(1) +
                          PROMPT('Initiation Queue')
 
             PARM       KWD(COMMITCTL) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('Commitment +
                          Control (N/Y)')
