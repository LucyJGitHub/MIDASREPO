/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Send LDA status in MOPERQ')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1487 - MIDAS SEND LDA STATUS IN MOPERQ                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 27May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPB010  *CREATE    Date 16Jan03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       CPB010 - Avoid DB Error by write message in Trace File      */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&Mem)        TYPE(*CHAR) LEN(50)
                 /* Message text sent to MOPERQ.  */
             DCL        VAR(&Msgdta)     TYPE(*CHAR) LEN(128) +
                 /* Message text sent to MRUNQ MOPERQ.  */
 
             DCL        VAR(&Cpyfld)   TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/*-------------------------------------------------------------------*/
/*  Global monitor message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ENDPGM))
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                  GOTO       CMDLBL(ENDPGM)
             ENDDO
 
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&Mem)
/************IF         COND(%SST(&Mem 1 29) *= ' ') THEN(DO)                         */ /*BG18886*/
             IF         COND(%SST(&Mem 1 29) *NE ' ') THEN(DO)                           /*BG18886*/
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&Mem) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                  DLYJOB     DLY(1)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CHGVAR     VAR(&Cpyfld) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
