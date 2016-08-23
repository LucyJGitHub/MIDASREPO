/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB RE Retail Accruals - COB Changes - Sel')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1416 - RE Retail Accruals - COB Changes - Replication.   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 26May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CPB002  *CREATE    Date 31Aug00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Msgdta)   TYPE(*CHAR) LEN(128)
             DCL        VAR(&Mem)      TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Send Notify Message to Message Queue MRUNQ.                      */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Msgdta) VALUE('           - RE Retail Accruals COB +
                          changes replication - RPC1416')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ)
 
/*-------------------------------------------------------------------*/
/*  Set switches U7 and U8 off.                                      */
/*-------------------------------------------------------------------*/
 
             CHGJOB     SWS(XXXXXX00)
 
/*-------------------------------------------------------------------*/
/*  Select RE Retail Accruals records that have been changed.        */
/*-------------------------------------------------------------------*/
 
             OVRDBF     FILE(REACRD) SHARE(*YES)
 
/************OPNQRYF    FILE((REACRD)) OPTION(*ALL) QRYSLT('REPI *= +
                          '' ''') KEYFLD((CUST) (ACCY) (ACOD) +
                          (ASEQ) (BRCA))                                              */ /*BG18886*/
             OPNQRYF    FILE((REACRD)) OPTION(*ALL) QRYSLT('REPI *NE +
                          '' ''') KEYFLD((CUST) (ACCY) (ACOD) +
                          (ASEQ) (BRCA))                                                 /*BG18886*/
 
/*-------------------------------------------------------------------*/
/*  Call RE Retail Accruals - COB Changes - Reset/Reports program.   */
/*-------------------------------------------------------------------*/
 
             CALL       PGM(RP1416)
 
/*-------------------------------------------------------------------*/
/*  Database error processing                                        */
/*-------------------------------------------------------------------*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&Mem)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&Mem) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) VALUE('RPC1416 - RE Retail Accruals COB +
                          changes replication - ended abnormally. See job log')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CLOF       OPNID(REACRD)
             MONMSG     MSGID(CPF0000)
 
             DLTOVR     FILE(REACRD)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
