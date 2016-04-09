/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB Retail Accruals        - take on')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1468  - Retail Accruals - Take On                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CPB002  *CREATE    Date 24Aug00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
              DCL       VAR(&MEM) TYPE(*CHAR) LEN(50)
              DCL       VAR(&MSGDTA) TYPE(*CHAR) LEN(128)
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
              MONMSG    MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Create LDA if not present.                                       */
/*-------------------------------------------------------------------*/
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                   CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                                AUT(*EXCLUDE)
             ENDDO
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/*-------------------------------------------------------------------*/
/*  Set switches U7 and U8 off.                                      */
/*  within scope of Private banking take on.                         */
/*-------------------------------------------------------------------*/
 
             CHGJOB     SWS(XXXXXX00)
 
/*-------------------------------------------------------------------*/
/*  Call program                                                     */
/*-------------------------------------------------------------------*/
 
              CALL      PGM(PB9502)
 
/*-------------------------------------------------------------------*/
/*  Database error processing                                        */
/*-------------------------------------------------------------------*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
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
 
             CHGVAR     VAR(&MSGDTA) +
                          VALUE('RPC1468 - Retail Accruals Take On +
                                - ended abnormally. See job log')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
