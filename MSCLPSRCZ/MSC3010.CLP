/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas S.W.I.F.T. TCP/IP FTP Transmission')            */
/*********************************************************************/
/*                                                                   */
/*       Midas   Midas S.W.I.F.T. Direct Link                */
/*                                                                   */
/*       MSC3010 - MS TCP/IP FTP TRANSMISSION                        */
/*                                                                   */
/*       Function : This program performs the FTP Transmission       */
/*                  to a remote machine and checks the result of     */
/*                  connection between the two systems.              */
/*                                                                   */
/*       Submitted By : MSC3001 - MS Compression/Transmission        */
/*                                                                   */
/*       Calls : MS3010 - MS Setup FTP Command File                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      S01408             Date 20Jun95              */
/*                     CSW001          DATE 20MAR95 *CREATE*        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*     CPK009 - Packaging for DBA3 release. STRCMTCTL values set    */
/*              to CMTSCOPE(*JOB).                                  */
/*     S01408 - Addition of core hook MSC3010MP1                    */
/*     CSW001 - SWIFT ALLIANCE Batch Transmission                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*/COPY WNCPYSRC,MSC3010001                                          */
             PGM
/*/COPY WNCPYSRC,MSC3010002                                          */
 
/**  Copyright statement definition                                */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/**  Declare variables                                             */
 
             DCL        VAR(&MSSTAT)   TYPE(*CHAR) LEN(256)
             DCL        VAR(&SBSID)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&XLIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODE)     TYPE(*CHAR) LEN(4) VALUE('SEND')
             DCL        VAR(&RETURN)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCPIP)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&CNN)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&WAIT)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&MAX)      TYPE(*DEC)  LEN(1 0)
             DCL        VAR(&RETRY)    TYPE(*DEC)  LEN(2 0) VALUE(0)
             DCL        VAR(&DTQLEN)   TYPE(*DEC)  LEN(5 0) VALUE(10)
/*/COPY WNCPYSRC,MSC3010010                                          */
 
/*/COPY WNCPYSRC,MSH00004                                            */
 
/**  Global Error Monitor Message                                  */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXXX00)
 
/**  Copyright statement definition - at runtime                   */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,MSC3010007                                          */
/**  Create Data Area LDA                                          */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                        TEXT('AS/400 - Equivalent of System/34 +
                        Local Data Area')
 
/*/COPY WNCPYSRC,MSC3010008                                          */
/** Start Commitment Control                                       */
 
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))             /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
/*/COPY WNCPYSRC,MSC3010009                                          */
 
/** Retrieve System Id. from SDSTAT                                */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2))  RTNVAR(&SBSID)
             CHGVAR     VAR(&XLIB)   VALUE(&SBSID *CAT 'XLIB')
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,MSC3010MP1                                     */    /*S01408*/
/**/                                                                  /*S01408*/
 
/** Retrieve TCP/IP transmission parameters                        */
 
             RTVDTAARA  DTAARA(MSSTAT (1 256))  RTNVAR(&MSSTAT)
 
             CHGVAR     VAR(&CNN)    VALUE((%SST(&MSSTAT 199 3)))
             CHGVAR     VAR(&RTCPIP) VALUE((%SST(&MSSTAT 156 20)))
             CHGVAR     VAR(&WAIT)   VALUE((%SST(&MSSTAT 196 2)))
             CHGVAR     VAR(&MAX)    VALUE((%SST(&MSSTAT 198 1)))
 
/** Override FTP files  INPUT & OUTPUT                             */
 
             OVRDBF     FILE(INPUT)  TOFILE(MSSENDPD)
             OVRDBF     FILE(OUTPUT) TOFILE(MSFTPOPD)
 
/** Start TCP/IP FTP function                                      */
 
START:
             CLRPFM     FILE(MSFTPOPD)
 
/*/COPY WNCPYSRC,MSH00005                                            */
             STRTCPFTP  RMTSYS(&RTCPIP) TBLFTPOUT(*DFT) +
                        TBLFTPIN(*DFT)
/*/COPY WNCPYSRC,MSH00006                                            */
 
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
/*/COPY WNCPYSRC,MSC3010011                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:      IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                        CHGJOB  SWS(XXXXXX11)
                        MONMSG  MSGID(CPF0000 MCH0000)
                        DMPCLPGM
                        MONMSG  MSGID(CPF0000 MCH0000)
             ENDDO
 
             SNDPGMMSG  MSG('MSC3010 - MS File Transfer Protocol +
                        Functions - ABNORMAL TERMINATION -') +
                        TOPGMQ(*PRV) TOMSGQ(MOPERQ QSYSOPR)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/**          Reset Message status for another transmission         */
 
/*/COPY WNCPYSRC,MSC3010003                                          */
             CALL       PGM(MS0203) PARM('R')
/*/COPY WNCPYSRC,MSC3010004                                          */
 
/** End of program                                                 */
 
 END:        DLTOVR     FILE(*ALL)
 
/*/COPY WNCPYSRC,MSC3010005                                          */
/** Update *DTAQ/MSTCPIP - Pass Control to calling Program         */
 
             IF         COND(&RETURN *EQ ' ') THEN(CHGVAR +
                          VAR(&RETURN) VALUE('MSC3020'))
 
             CALL       PGM(QSNDDTAQ) PARM(MSTCPIP &XLIB &DTQLEN +
                          &RETURN)
/*/COPY WNCPYSRC,MSC3010006                                          */
             ENDPGM
