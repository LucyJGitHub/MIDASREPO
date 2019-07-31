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
/*       Last Amend No. CSC053             Date 20Aug18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      S01408             Date 20Jun95              */
/*                     CSW001          DATE 20MAR95 *CREATE*        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*                                                                  */
/*       CSC053 - FTP Secure Connections to SWIFT and Correspondence */
/*                Manager modules.                                   */
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
                                                                                          /*CSC053*/
/**  Shared return code */                                                                /*CSC053*/
             DCL        VAR(&RTNCDE)   TYPE(*CHAR) LEN(7)                                 /*CSC053*/
                                                                                          /*CSC053*/
/**  Parameter for call to AOSARDR0 */                                                    /*CSC053*/
             DCL        VAR(&OPTN)     TYPE(*CHAR) LEN(7)                                 /*CSC053*/
             DCL        VAR(&SAR)      TYPE(*CHAR) LEN(6)                                 /*CSC053*/
             DCL        VAR(&SCSARD)   TYPE(*CHAR) LEN(200)                               /*CSC053*/
                                                                                          /*CSC053*/
/**  Parameter for call to AOSVALR0 */                                                    /*CSC053*/
             DCL        VAR(&SVAL1)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK2)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL2)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK3)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL3)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK4)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL4)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK5)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL5)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK6)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL6)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK7)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL7)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK8)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL8)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK9)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL9)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK0)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL10)   TYPE(*CHAR) LEN(200)                               /*CSC053*/
                                                                                          /*CSC053*/
/**  Result fields  */                                                                    /*CSC053*/
             DCL        VAR(&CSC053)   TYPE(*CHAR) LEN(1)                                 /*CSC053*/
             DCL        VAR(&FTPS)     TYPE(*CHAR) LEN(1)                                 /*CSC053*/
             DCL        VAR(&PORT)     TYPE(*CHAR) LEN(5)                                 /*CSC053*/
 
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
 
/** Access CSC053 Feture                                           */                     /*CSC053*/
             CHGVAR     VAR(&SAR) VALUE('CSC053')                                         /*CSC053*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC053*/
             CHGVAR     VAR(&CSC053) VALUE('N')                                           /*CSC053*/
                                                                                          /*CSC053*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SAR &SCSARD)                    /*CSC053*/
             IF         COND(&RTNCDE *EQ '       ') THEN(DO)                              /*CSC053*/
                        CHGVAR     VAR(&CSC053) VALUE('Y')                                /*CSC053*/
                                                                                          /*CSC053*/
/** Get 'UseFTPSecureSWIFT' system value from file SDSVALPD  */                           /*CSC053*/
                                                                                          /*CSC053*/
             CALL       PGM(AOSVALR0) PARM(&RTNCDE +
                           'UseFTPSecureSWIFT' &SVAL1 &SVALK2 +
                            &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                            &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                            &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                            &SVALK0 &SVAL10)                                              /*CSC053*/
                                                                                          /*CSC053*/
/** If the 'UseFTPSecureSWIFT' system value is missing then end abnormally */             /*CSC053*/
                                                                                          /*CSC053*/
                   IF         COND(%SST(&SVAL1 1 4) *EQ '*NRF') THEN(GOTO +
                                CMDLBL(ABNOR))                                            /*CSC053*/
                   ELSE       CMD(DO)                                                     /*CSC053*/
                              CHGVAR     VAR(&FTPS) VALUE(%SST(&SVAL1 1 1))               /*CSC053*/
                   ENDDO                                                                  /*CSC053*/
             ENDDO                                                                        /*CSC053*/
                                                                                          /*CSC053*/
/** Use secure sockets layer for FTP if feature CSC053 switched ON */                     /*CSC053*/
/** and system value UseFTPSecureSWIFT is set to 'Y' */                                   /*CSC053*/
                                                                                          /*CSC053*/
             IF         COND(&CSC053 *EQ 'Y' *AND &FTPS *EQ 'Y') THEN(DO)                 /*CSC053*/
                                                                                          /*CSC053*/
/** Retrieve the configured secure port number */                                         /*CSC053*/
                                                                                          /*CSC053*/
             CALL       PGM(AOSVALR0) PARM(&RTNCDE +
                           'FTPSecurePortNumber' &SVAL1 &SVALK2 +
                            &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                            &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                            &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                            &SVALK0 &SVAL10)                                              /*CSC053*/
                                                                                          /*CSC053*/
/** If the 'FTPSecurePortNumber' system value is missing then end abnormally */           /*CSC053*/
                                                                                          /*CSC053*/
                   IF         COND(%SST(&SVAL1 1 4) *EQ '*NRF') THEN(GOTO +
                                CMDLBL(ABNOR))                                            /*CSC053*/
                   ELSE       CMD(DO)                                                     /*CSC053*/
                              CHGVAR     VAR(&PORT) VALUE(%SST(&SVAL1 1 5))               /*CSC053*/
                   ENDDO                                                                  /*CSC053*/
                                                                                          /*CSC053*/
             ENDDO                                                                        /*CSC053*/

/** Start TCP/IP FTP function                                      */
 
START:
             CLRPFM     FILE(MSFTPOPD)
 
/*/COPY WNCPYSRC,MSH00005                                            */
                                                                                          /*CSC053*/
/** Use secure sockets layer for FTP if feature CSC053 switched ON */                     /*CSC053*/
/** and system value UseFTPSecureSWIFT is set to 'Y' */                                   /*CSC053*/
                                                                                          /*CSC053*/
             IF         COND(&CSC053 *EQ 'Y' *AND &FTPS *EQ 'Y') THEN(DO)                 /*CSC053*/
                                                                                          /*CSC053*/
/** Execute the secure FTP operation */                                                   /*CSC053*/
                                                                                          /*CSC053*/
             STRTCPFTP  RMTSYS(&RTCPIP) TBLFTPOUT(*DFT) +
                        TBLFTPIN(*DFT) SECCNN(*SSL) PORT(&PORT)                           /*CSC053*/
             ENDDO                                                                        /*CSC053*/
             ELSE       CMD(DO)                                                           /*CSC053*/
             STRTCPFTP  RMTSYS(&RTCPIP) TBLFTPOUT(*DFT) +
                        TBLFTPIN(*DFT)
             ENDDO                                                                        /*CSC053*/
                                                                                          /*CSC053*/
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
