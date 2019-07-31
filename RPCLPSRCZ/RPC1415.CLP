/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP FF Commis. & charges COB Changes - Select')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian DBA Replication                            */
/*                                                                   */
/*       RPC1415 - FF Commis. & Charges - COB Changes - Replication. */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 26May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK022             Date 26Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CFF007  *CREATE    Date 13Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       CPK022 - Release 4.02 packaging.  Correct the name of       */
/*                FFCOCH to FFCOCHPD.                                */
/*       CFF007 - Futures and Options Enhancement for Private        */
/*                Banking.                                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)      TYPE(*CHAR) LEN(50)
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Send Notify Message to Message Queue MRUNQ.                      */
/*-------------------------------------------------------------------*/
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('FF +
                          Commis. & Charges COB changes +
                          replication') TOMSGQ(MRUNQ)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*-------------------------------------------------------------------*/
/*  Select FF Commis. & Charges records that have been changed.      */
/*-------------------------------------------------------------------*/
 
/**********  OVRDBF     FILE(FFCOCH) SHARE(*YES)      */                                  /*CPK022*/
/**********  OPNQRYF    FILE((FFCOCH)) OPTION(*ALL) + */                                  /*CPK022*/
/**********               QRYSLT('CCREPI *= '' ''') + */                                  /*CPK022*/
/**********               KEYFLD((CCTNBR))            */                                  /*CPK022*/
                                                                                          /*CPK022*/
             OVRDBF     FILE(FFCOCHPD) SHARE(*YES)                                        /*CPK022*/
/**********  OPNQRYF    FILE((FFCOCHPD)) OPTION(*ALL) */                      /*CPK022*/ /*BG18886*/
/**********               QRYSLT('CCREPI *= '' ''') + */                      /*CPK022*/ /*BG18886*/
/**********               KEYFLD((CCTNBR))            */                      /*CPK022*/ /*BG18886*/
             OPNQRYF    FILE((FFCOCHPD)) OPTION(*ALL) +
                          QRYSLT('CCREPI *NE '' ''') +
                          KEYFLD((CCTNBR))                                    /*CPK022*/ /*BG18886*/
/*-------------------------------------------------------------------*/
/*  Call FF Commis. & Charges - COB Changes - Reset/Reports program  */
/*-------------------------------------------------------------------*/
 
             CALL       PGM(RP1415)
 
/**********  CLOF       OPNID(FFCOCH) */                                                  /*CPK022*/
             CLOF       OPNID(FFCOCHPD)                                                   /*CPK022*/
             MONMSG     MSGID(CPF0000)
 
/**********  DLTOVR     FILE(FFCOCH) */                                                   /*CPK022*/
             DLTOVR     FILE(FFCOCHPD)                                                    /*CPK022*/
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
 
             GOTO       CMDLBL(END)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          RPC1415 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
