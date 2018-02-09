/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TrOpics I/face - Startup Procedure')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication                                         */
/*                                                                   */
/*     RPC9999 - Midas-TrOpics Interface - Start PROCEDURE AFTER IPL */
/*                                                                   */
/*       (C) COPYRIGHT Finastra International Limited 2005           */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSD026             Date 05Apr05              */
/*                      UTROPX  *CREATE    Date 21Dec01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSD026 - Midas-TrOpics Interface upgrade to MidasPlus       */
/*       UTROPX - Midas-TrOpics Interface                            */
/*                                                                   */
/*********************************************************************/
             PGM
             STRMQM
             MONMSG     MSGID(AMQ0000 CPF0000 MCH0000) +
                          EXEC(SNDPGMMSG MSG('Possible error in MQ +
                          Series Startup during QSTRUP on STRMQM +
                          command, check joblog') TOMSGQ(*SYSOPR))
             STRMQMLSR
             MONMSG     MSGID(AMQ0000 CPF0000 MCH0000) +
                          EXEC(SNDPGMMSG MSG('Possible error in MQ +
                          Series Startup during QSTRUP on STRMQMLSR +
                          command, check joblog') TOMSGQ(*SYSOPR))
/*           STRMQMCHL  CHLNAME(REP.OPXEX.OP)                      UOL011 */
/*           MONMSG     MSGID(AMQ0000 CPF0000 MCH0000) +
                          EXEC(SNDPGMMSG MSG('Possible error in MQ +
                          Series Startup during QSTRUP on STRMQMCHL +
                          command, check joblog') TOMSGQ(*SYSOPR))      UOL011 */
             ENDPGM
