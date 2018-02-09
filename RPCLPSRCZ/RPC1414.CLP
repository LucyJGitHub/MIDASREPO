/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP FF close out details COB changes - select')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication                                         */
/*                                                                   */
/*       RPC1414 - FF Close out details - COB Changes - Replication. */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 26May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      203362             Date 18Oct02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CFF007  *CREATE    Date 13Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       203362 - Do not process market entered today.               */
/*       CFF007 - Futures and Options Enhancement for Private        */
/*                Banking.                                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&LIBID) TYPE(*CHAR) LEN(2)                                    /*203362*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)                                    /*203362*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)      TYPE(*CHAR) LEN(50)
 
             DCLF       FILE(MARKTD)
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Send Notify Message to Message Queue MRUNQ.                      */
/*-------------------------------------------------------------------*/
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('FF +
                          Close out Details COB changes +
                          replication') TOMSGQ(MRUNQ)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*-------------------------------------------------------------------*/                   /*203362*/
/*  Retrieve xxDPLIB into a variable.                                */                   /*203362*/
/*-------------------------------------------------------------------*/                   /*203362*/
                                                                                          /*203362*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBID)                               /*203362*/
             CHGVAR     VAR(&DPLIB) VALUE(&LIBID *CAT 'DPLIB')                            /*203362*/
                                                                                          /*203362*/
/*-------------------------------------------------------------------*/
/*  Select FF Close out OTC details records that have been changed.  */
/*-------------------------------------------------------------------*/
 
             OVRDBF     FILE(CLOSTD) MBR(OTC) SHARE(*YES)
 
/*********** OPNQRYF    FILE((CLOSTD OTC)) OPTION(*ALL) QRYSLT('REPI +
                          *= '' ''') KEYFLD((CLON))                                   */ /*BG18886*/
             OPNQRYF    FILE((CLOSTD OTC)) OPTION(*ALL) QRYSLT('REPI +
                          *NE '' ''') KEYFLD((CLON))                                     /*BG18886*/
             CHGVAR     VAR(&MRKT) VALUE('  ')
             CHGVAR     VAR(&MKTN) VALUE('OVER THE COUNTER')
 
             GOTO       CMDLBL(FIRST)
 
/*-------------------------------------------------------------------*/
/*  Select FF Close out details records that have been changed.      */
/*-------------------------------------------------------------------*/
 RCV:        RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
             IF         COND(&RECI *EQ '*') THEN(DO)
                  GOTO       CMDLBL(RCV)
             ENDDO
                                                                                          /*203362*/
             CHKOBJ     OBJ(&DPLIB/&MRKT) OBJTYPE(*DTAARA)                                /*203362*/
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(RCV))                             /*203362*/
 
             OVRDBF     FILE(CLOSTD) MBR(&MRKT) SHARE(*YES)
/************OPNQRYF    FILE((CLOSTD &MRKT)) OPTION(*ALL) +
                          QRYSLT('REPI *= '' ''') KEYFLD((CLON))                      */ /*BG18886*/
             OPNQRYF    FILE((CLOSTD &MRKT)) OPTION(*ALL) +
                          QRYSLT('REPI *NE '' ''') KEYFLD((CLON))                        /*BG18886*/
 
/*-------------------------------------------------------------------*/
/*  Call FF Close out Details - COB Changes - Reset/Reports program. */
/*-------------------------------------------------------------------*/
 FIRST:
             CALL       PGM(RP1414) PARM(&MRKT &MKTN)
 
             CLOF       OPNID(CLOSTD)
             MONMSG     MSGID(CPF0000)
 
             DLTOVR     FILE(CLOSTD)
             MONMSG     MSGID(CPF0000)
 
/*-------------------------------------------------------------------*/
/*  Database error processing                                        */
/*-------------------------------------------------------------------*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(RCV)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          RPC1414 ended abnormally - see job log') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
