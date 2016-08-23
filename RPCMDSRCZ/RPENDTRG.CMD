/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1303)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RPENDTRG)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas RP PB Stop Midas/TOF MQSeries Q. triggering.')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPDSTRTRG  - Stop Midas/TOF interface Queues Triggering.    */
/*                                                                   */
/*       Function: this command stops triggering by submitting       */
/*                 one job for each Initiation Queue, that is        */
/*                 currently being monitored. Each of these jobs     */
/*                 will put a "SHUTDOWN" message on the Initiation   */
/*                 queue so that trigger server would stop.          */
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
 
             CMD        PROMPT('Stop Midas/TOF Queues Trigg.')
