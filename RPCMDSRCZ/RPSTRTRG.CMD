/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1310)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RPSTRTRG)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas RP PB Start Midas/TOF MQSeries Q. triggering')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPDSTRTRG  - Start Midas/TOF interface Queues Triggering.   */
/*                                                                   */
/*       Function: this command starts triggering by submitting      */
/*                 one Trigger Server for each Initiation Queue      */
/*                 that was defined in file RPINIQPD with Triggering */
/*                 type "Q" and is flagged as active.                */
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
 
             CMD        PROMPT('Start Midas/TOF Queues Trigg.')
