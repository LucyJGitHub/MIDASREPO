/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1315)    VLDCKR(RPC1315_V)  MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RPSTRCHLI)  HLPID(*CMD)                            */
/*EXI *  TEXT('Midas RP PB Start Midas/TOF Channel Initiators.')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPSTRCHLI - Start Midas/TOF interface Channel Initiators.   */
/*                                                                   */
/*       Function: this command allows to start channel initiator    */
/*                 that is used to automatically start channel.      */
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
 
             CMD        PROMPT('Midas/TOF Channel Initiators')
 
             PARM       KWD(INITQUEUE) TYPE(*GENERIC) LEN(48) +
                          DFT(*ALL) SPCVAL((*ALL)) +
                          PROMPT('Initiation Queue Name')
