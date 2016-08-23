/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP Plato interface - download entire system')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication                                         */
/*                                                                   */
/*       RPC1020 - Midas-Plato Interface - Download entire system.   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. CPL003  *CREATE    Date 11Oct99              */
/*       Prev Amend No. ------             Date --------             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPL003 - Midas-Plato Interface.                             */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(RPAPCIL1)
 
/* Global Monitor Message:                                         */
/* If an unmonitorred message occurs perform error processing      */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
             SNDPGMMSG  MSG('RPC1020 Midas-Plato Interface - +
                          Download Entire Midas System') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             CHGJOB     SWS(XXXXXX00)
 
/* Receive message names from PF/RPAPCIPD.                          */
 
             OVRDBF     FILE(RPAPCIL1) MBR(MIDASPLATO)
 TAG001:
             RCVF       RCDFMT(RPAPCID0)
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(TAG002))
 
/* Use Replication command to process all records on each table.     */
 
             IF         COND(&RBPROCSEQ *NE 00) THEN(DO)
               KMDDLC     PRODUCT(PLINT) TYPE(*LIST) TABLES(&RBTABLENM)
             ENDDO
 
             GOTO       CMDLBL(TAG001)
 TAG002:
             DLTOVR     FILE(RPAPCIL1)
 
             GOTO       CMDLBL(TAG999)
 
/* Error Processing:                                               */
/* Dump the program if error occurred in this program              */
TAG998:
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDMSG     MSG('Job terminated - RPC1020 Download +
                          entire Midas system to Plato - Ended in +
                          Error') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
/* End of Program:                                                 */
TAG999:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
