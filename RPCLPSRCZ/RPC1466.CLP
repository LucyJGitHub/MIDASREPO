/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB Forward Rates Tables - take on')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1466  - Forward Rates Table - Take On                    */
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
/*                                                                   */
/*********************************************************************/
             PGM
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
/*  Remove all Triggering of the File                                */
/*-------------------------------------------------------------------*/
 
             RMVPFTRG   FILE(FWDRTFE) TRGTIME(*ALL) TRGEVENT(*ALL)
             MONMSG    MSGID(CPF0000)
 
             CLRPFM     FILE(FWDRMIR)
             MONMSG    MSGID(CPF0000)
 
/*-------------------------------------------------------------------*/
/*  Call program                                                     */
/*-------------------------------------------------------------------*/
 
              CALL      PGM(PB6600)
 
/*-------------------------------------------------------------------*/
/*  Database error processing                                        */
/*-------------------------------------------------------------------*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Add all Triggering for the file                                  */
/*-------------------------------------------------------------------*/
 
             ADDPFTRG   FILE(FWDRTFE) TRGTIME(*AFTER) +
                          TRGEVENT(*UPDATE) PGM(PB6602) +
                          TRGUPDCND(*CHANGE)
 
             ADDPFTRG   FILE(FWDRTFE) TRGTIME(*AFTER) +
                          TRGEVENT(*INSERT) PGM(PB6602)
 
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
                          VALUE('RPC1466 - Forward Rates Table Take On +
                                - ended abnormally. See job log')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
