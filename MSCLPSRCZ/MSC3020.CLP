/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas S.W.I.F.T. TCP/IP FTP Receive/Update')          */
/*********************************************************************/
/*                                                                   */
/*       Midas   Midas S.W.I.F.T. Direct Link                */
/*                                                                   */
/*       MSC3020 - MS TCP/IP FTP RECEIVE/UPDATE                      */
/*                                                                   */
/*       Function : This program performs the FTP RECEIPT Function   */
/*                  from a remote machine and checks the result of   */
/*                  connection between the two systems.              */
/*                                                                   */
/*       Submitted By : MSC3002 - MS Message Receiver                */
/*                                                                   */
/*       Calls : MS3010 - MS Monitor TCP/IP FTP Operation.           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     Last Amend No. CPK009           Date 09Aug99                  */
/*     LAST AMEND NO.  S01408          DATE 19JUN95                 */
/*     PREV AMEND NO.  CSW001          DATE 20MAR95 *CREATE*        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     CPK009 - Packaging for DBA3 release. STRCMTCTL values set     */
/*              to CMTSCOPE(*JOB).                                   */
/*     S01408 - Addition of Core Hook MSC3020MP1                     */
/*     CSW001 - SWIFT ALLIANCE Batch Transmission                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM
 
/**  Copyright statement definition                                */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/**  Declare variables                                             */
 
             DCL        VAR(&MEM)      TYPE(*CHAR) LEN(44)
             DCL        VAR(&MSSTAT)   TYPE(*CHAR) LEN(256)
             DCL        VAR(&SBSID)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&XLIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODE)     TYPE(*CHAR) LEN(4) VALUE('RCVF')
             DCL        VAR(&RETURN)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCPIP)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&CNN)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&WAIT)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&MAX)      TYPE(*DEC)  LEN(1 0)
             DCL        VAR(&RETRY)    TYPE(*DEC)  LEN(2 0) VALUE(0)
             DCL        VAR(&DTQLEN)   TYPE(*DEC)  LEN(5 0) VALUE(10)
 
/*/COPY WNCPYSRC,MSH00007                                            */
 
/**  Global Error Monitor Message                                  */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXXX00)
 
/**  Copyright statement definition - at runtime                   */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/**  Create Data Area LDA                                          */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                        TEXT('AS/400 - Equivalent of System/34 +
                        Local Data Area')
 
/** Start Commitment Control                                       */
 
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))             /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
 
/** Retrieve System Id. from SDSTAT                                */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2))  RTNVAR(&SBSID)
             CHGVAR     VAR(&XLIB)   VALUE(&SBSID *CAT 'XLIB')
 
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MSC3020MP1                                          */
                                                                      /*S01408*/
/** Retrieve TCP/IP transmission parameters                        */
 
             RTVDTAARA  DTAARA(MSSTAT (1 256))  RTNVAR(&MSSTAT)
 
             CHGVAR     VAR(&CNN)    VALUE((%SST(&MSSTAT 199 3)))
             CHGVAR     VAR(&RTCPIP) VALUE((%SST(&MSSTAT 156 20)))
             CHGVAR     VAR(&WAIT)   VALUE((%SST(&MSSTAT 196 2)))
             CHGVAR     VAR(&MAX)    VALUE((%SST(&MSSTAT 198 1)))
 
/** Override FTP files  INPUT & OUTPUT                             */
 
             OVRDBF     FILE(INPUT)  TOFILE(MSRCVFPD)
             OVRDBF     FILE(OUTPUT) TOFILE(MSFTPOPD)
 
/** Start TCP/IP FTP function                                      */
 
START:
             CLRPFM     FILE(MSFTPOPD)
 
/*/COPY WNCPYSRC,MSH00008                                            */
             STRTCPFTP  RMTSYS(&RTCPIP) TBLFTPOUT(*DFT) +
                        TBLFTPIN(*DFT)
/*/COPY WNCPYSRC,MSH00009                                            */
 
/** Read the FTP Output file                                       */
 
             CALL       PGM(MS3010) PARM(&RETURN &MODE)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        SNDPGMMSG  MSG('MS3010 MS Monitor FTP Output  +
                        ended abnormally') TOPGMQ(*PRV) TOMSGQ(QSYSOPR +
                        MOPERQ)
                        GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/** If the FTP operation failed due to an incorrect remote user id */
/** and password combination - send a message to the user and      */
/** goto ABNOR                                                     */
 
             IF         COND(&RETURN *EQ 'LOGIN') THEN(DO)
                        SNDPGMMSG  MSG('MS3010 : INVALID LOGIN - Check +
                        USERID/PASSWORD') TOPGMQ(*PRV) +
                        TOMSGQ(QSYSOPR MOPERQ)
                        GOTO       CMDLBL(ABNOR)
             ENDDO
 
/** If the FTP operation failed, wait and then retry               */
 
             IF         COND(&RETURN *EQ 'FAILED') THEN(DO)
                        CHGVAR     VAR(&RETRY) VALUE(&RETRY + 1)
 
                        IF   COND(&RETRY *LE &MAX) THEN(DO)
                        DLYJOB     DLY(&WAIT)
                        GOTO       CMDLBL(START)
                        ENDDO
 
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/**          Normal termination - update SWIFT Reference file      */
/**                             - ASCII/EBCDIC conversion          */
 
             CHGJOB     SWS(XXXXXX00)
             CALL       PGM(MS0207B)
 
/* Notify Database errors to MOPERQ :                           */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        SNDPGMMSG  MSG('MS0207B : Error in Data Conversion +
                        (ASCII/EBCDIC)') TOPGMQ(*PRV) TOMSGQ(QSYSOPR MOPERQ)
                        CHGVAR     VAR(&RETURN) VALUE('MS0204B')
                        GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                        CHGJOB  SWS(XXXXXX11)
                        MONMSG  MSGID(CPF0000 MCH0000)
                        DMPCLPGM
                        MONMSG  MSGID(CPF0000 MCH0000)
             ENDDO
 
             SNDPGMMSG  MSG('MSC3020 - MS File Transfer Protocol +
                        Functions - ABNORMAL TERMINATION -') +
                        TOPGMQ(*PRV) TOMSGQ(MOPERQ QSYSOPR)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/** End of program                                                 */
 
 END:        DLTOVR     FILE(*ALL)
 
/** Update *DTAQ/MSTCPIP - Pass Control to calling Program         */
 
             IF         COND(&RETURN *EQ ' ') THEN(CHGVAR +
                          VAR(&RETURN) VALUE('MSC3020'))
 
             CALL       PGM(QSNDDTAQ) PARM(MSTCPIP &XLIB &DTQLEN +
                          &RETURN)
             ENDPGM
