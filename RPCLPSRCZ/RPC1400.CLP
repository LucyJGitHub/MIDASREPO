/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB C.O.B. Files Replication.')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1400 - C.O.B. Files Replication.                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 26May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPB010             Date 16Jan03              */
/*                      195756             Date 26Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       CPB010 - Avoid DB Error by write message in Trace File      */
/*       195756 - Unmonitored message in Replication caused the job  */
/*                to go on message wait in CoB.                      */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CompName &Sequence)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&CompName) TYPE(*CHAR) LEN(10)
             DCL        VAR(&Sequence) TYPE(*DEC)  LEN(5 0)
 
             DCL        VAR(&PSCAN)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRODUCT)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PSCANL)   TYPE(*DEC)  LEN(3 0)    VALUE(10)
             DCL        VAR(&PSTART)   TYPE(*DEC)  LEN(3 0)    VALUE(1)
             DCL        VAR(&PMASK)    TYPE(*CHAR) LEN(2)      VALUE('XX')
             DCL        VAR(&PMASKL)   TYPE(*DEC)  LEN(3 0)    VALUE(2)
             DCL        VAR(&PTRANS)   TYPE(*CHAR) LEN(1)      VALUE('1')
             DCL        VAR(&PTRIM)    TYPE(*CHAR) LEN(1)      VALUE('1')
             DCL        VAR(&PWILD)    TYPE(*CHAR) LEN(1)      VALUE('?')
             DCL        VAR(&PRESULT)  TYPE(*DEC)  LEN(3 0)    VALUE(0)
             DCL        VAR(&PBEGIN)   TYPE(*DEC)  LEN(3 0)    VALUE(0)
             DCL        VAR(&PEND)     TYPE(*DEC)  LEN(3 0)    VALUE(0)
             DCL        VAR(&PTOTAL)   TYPE(*DEC)  LEN(3 0)    VALUE(0)
             DCL        VAR(&SBS)      TYPE(*CHAR) LEN(2)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Switches) TYPE(*CHAR) LEN(8)
             DCL        VAR(&Msgdta)   TYPE(*CHAR) LEN(128)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  C.O.B. files replication file declaration.                       */
/*-------------------------------------------------------------------*/
 
             DCLF       FILE(RPCOBRL2) RCDFMT(RPCOBRD0)
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Send Notify Message to Message Queue MRUNQ.                      */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SBS)
 
             IF         COND(&Sequence = 1) THEN(DO)
                   CALL       PGM(RPC1485)                                                /*CPB010*/
                   CHGVAR     VAR(&Msgdta) +
                                VALUE('RPC1400 - C.O.B. files replication +
                                       - Reset' )
                   CHGVAR     VAR(&Switches) VALUE('0XXXXX00')
             ENDDO
             ELSE       CMD(DO)
                   CHGVAR     VAR(&Msgdta) +
                                VALUE('RPC1400 - C.O.B. files replication +
                                       - Download' )
                   CHGVAR     VAR(&Switches) VALUE('1XXXXX00')
             ENDDO
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ)
 
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
/*  Set off Job Switches.                                            */
/*-------------------------------------------------------------------*/
 
             CHGJOB     SWS(&Switches)
 
/*-------------------------------------------------------------------*/
/*  Process all C.O.B. files.                                        */
/*-------------------------------------------------------------------*/
 
 RCVF:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
 
/*-------------------------------------------------------------------*/
/*  Download file if "replication field name" equal to blank         */
/*-------------------------------------------------------------------*/
 
/************IF         COND(&Sequence = 2 *AND &CBACTI *= 'Y') THEN(DO)              */ /*BG18886*/
             IF         COND(&Sequence = 2 *AND &CBACTI *NE 'Y') THEN(DO)                /*BG18886*/
                   GOTO       CMDLBL(RCVF)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Download file if "replication field name" equal to blank         */
/*-------------------------------------------------------------------*/
 
             IF         COND(&Sequence = 2 *AND &CBRFDN = '          ') THEN(DO)
                   CHGVAR     VAR(&PSCAN) VALUE(&CBPRDN)
                   CHGVAR     VAR(&PRODUCT) VALUE(&CBPRDN)
 
                   CALL       PGM(QCLSCAN) PARM(&PSCAN &PSCANL &PSTART +
                                  &PMASK &PMASKL &PTRANS &PTRIM &PWILD +
                                  &PRESULT)
 
                   IF         COND(&PRESULT > 1) THEN(DO)
                          CHGVAR     VAR(&PBEGIN) VALUE(&PRESULT)
                          CHGVAR     VAR(&PEND) VALUE(&PRESULT)
                          CHGVAR     VAR(&PEND) VALUE(&PEND + 2)
                          CHGVAR     VAR(&PTOTAL) VALUE(10)
                          CHGVAR     VAR(&PTOTAL) VALUE(&PTOTAL - &PEND)
                          CHGVAR     VAR(&PBEGIN) VALUE(&PBEGIN - 1)
 
                          CHGVAR     VAR(&PRODUCT) VALUE(%SST(&CBPRDN 1 &PBEGIN) +
                                     *CAT &SBS *CAT %SST(&cbprdn &PEND &PTOTAL))
                   ENDDO
 
                   KMDDLC     PRODUCT(&PRODUCT) SERVER(&CBDSMN) +
                                TYPE(*LIST) TABLES(&CBFILN)
                   MONMSG     MSGID(KCM6600 KCM6601) EXEC(GOTO CMDLBL(ABNOR))             /*195756*/
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Run program that resets Replication field or deletes record,     */
/*  and prints reports, only if required.                            */
/*-------------------------------------------------------------------*/
 
/************IF         COND(&CBPGMN *= ' ') THEN(DO)                                 */ /*BG18886*/
             IF         COND(&CBPGMN *NE ' ') THEN(DO)                                   /*BG18886*/
                 CALL   PGM(&CBPGMN)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Database error processing.                                       */
/*-------------------------------------------------------------------*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(RCVF)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) VALUE('RPC1400 - C.O.B. +
                          files replication - ended abnormally. See job log')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
