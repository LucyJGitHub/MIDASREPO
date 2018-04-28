/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS S.W.I.F.T. TCP/IP FTP compr/trans')          */
/********************************************************************/
/*                                                                  */
/*     MIDAS/S.W.I.F.T. DIRECT LINK                                 */
/*                                                                  */
/*     MSC3001  - TCP/IP BATCH TRANSFER WITH FTP                    */
/*                COMMUNICATIONS/COMPRESSION PROGRAM                */
/*                                                                  */
/*                CALLED BY MSC0201                                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 123698             Date 08Oct97              */
/*                      120202             Date 17Sep97              */
/*                     118084          DATE 16MAY97                 */
/*                     110242          DATE 07NOV96                 */
/*                     S01408          DATE 20JUN95                 */
/*                     CSW001          DATE 20MAR95 *CREATE*        */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.   */
/*                OUTQ must always be *JOBD.                        */
/*     123698 - Change SBMJOB to use the Language,Country & CCSID   */
/*              of the system instead of those of the current job.  */
/*              This avoids syntax errors with the FTP              */
/*     120202 - AOMGMER0 parameters have changed                    */
/*     118084 - Don't bother with CHGCMD if not authorised          */
/*     110242 - Change defaults for SBMJOB cmd to take *JOBD        */
/*     S01408 - Addition of core hook MSC3001MP1                    */
/*     CSW001 - SWIFT ALLIANCE Batch Transmission                   */
/*                                                                  */
/********************************************************************/
/*/COPY WNCPYSRC,MSC3001001                                          */
             PGM
/*/COPY WNCPYSRC,MSC3001002                                          */
/* ** Programmer note **                                             */
/*    Any changes to this program may also need to applied to MSC0201*/
 
/* Copyright statement definition                               */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Declare variables :                                          */
 
             DCL        VAR(&MEM)      TYPE(*CHAR) LEN(44)
             DCL        VAR(&LDA)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&SBSID)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&XLIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&RPY)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNCODE)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&RETURN)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACCOPT)   TYPE(*CHAR) LEN(7)
/************DCL        VAR(&MSMGME)   TYPE(*CHAR) LEN(26)            /*120202*/
             DCL        VAR(&MSMGME)   TYPE(*CHAR) LEN(800)           /*120202*/
             DCL        VAR(&PROTOCOL) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CNN)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&MODE)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&DTQLEN)   TYPE(*DEC)  LEN(5 0) VALUE(10)
             DCL        VAR(&DTQW)     TYPE(*DEC)  LEN(5 0) VALUE(-1)
/*/COPY WNCPYSRC,MSC3001011                                          */
             DCLF       FILE(MS2780DF)
 
/* Global message monitor :                                     */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABEND))
 
/**  Copyright statement definition - at runtime                   */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/* Set off all Job switches :                                   */
 
             CHGJOB     SWS(00000000)
 
/* Call access object for swift direct link ICD to check protocol */
 
             CHGVAR     VAR(&RTNCODE) VALUE('*MSG   ')
             CHGVAR     VAR(&ACCOPT) VALUE('*FIRST ')
 
             CALL    PGM(AOMGMER0) PARM(&RTNCODE &ACCOPT &MSMGME)
 
/* This option only valid for TCP/IP link USING FTP               */
 
             CHGVAR     VAR(&PROTOCOL) VALUE(%SST(&MSMGME 17 4))
             IF         COND(&PROTOCOL *NE 'TCPF') THEN(DO)
                        SNDPGMMSG  MSG('This Option only valid with the  +
                        TCP/IP File Transfer Protocol') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ)
                        GOTO       CMDLBL(END)
             ENDDO
/*/COPY WNCPYSRC,MSC3001012                                          */
 
/* Check FTP Transmission is not already running                */
/* Allocate Dataarea to limit calls to Alliance                 */
 
 
             ALCOBJ     OBJ((MS0200 *DTAARA *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                        SNDPGMMSG  MSG('SWIFT Send/Receive program already +
                         active') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        GOTO       CMDLBL(END)
             ENDDO
 
             ALCOBJ     OBJ((MS4010 *DTAARA *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                        SNDPGMMSG  MSG('SWIFT Send/Receive program already +
                         active') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        GOTO       CMDLBL(END)
             ENDDO
 
/* Send notification of Compression startup :                   */
 
             SNDPGMMSG  MSG('SWIFT Compression program starting') +
                          TOMSGQ(MRUNQ)
 
/* Display screen message for transmission active               */
 
             CHGVAR     VAR(&TEXT) VALUE('Midas/S.W.I.F.T. Message +
                          Transmission         ')
             SNDRCVF    RCDFMT(MS2780S) WAIT(*YES)
/*/COPY WNCPYSRC,MSC3001015                                          */
 
/* Call S.W.I.F.T. Message Compression program :                */
 
             CLRPFM     FILE(MS2780O)
/*/COPY WNCPYSRC,MSC3001003                                          */
             CALL       PGM(MS0208)
/*/COPY WNCPYSRC,MSC3001004                                          */
 
/* Notify Database errors to MOPERQ :                           */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        ROLLBACK
                        GOTO       CMDLBL(ABEND)
             ENDDO
 
/* Notify no data to sent to MOPERQ :                           */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                        SNDPGMMSG  MSG('No messages are ready for  +
                        transmission') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        GOTO       CMDLBL(END)
             ENDDO
 
/* Conversion EBCDIC to ASCII before transmission to Alliance   */
 
             CLRPFM     FILE(MSTCPFPD)
             CALL       PGM(MS0208B)
 
/* Notify Database errors to MOPERQ :                           */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('Conversion Error EBCDIC/ASCII for +
                          transmission') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        GOTO       CMDLBL(ABEND)
             ENDDO
 
/* Check the Message Switch line :                              */
/*   =====>  for Point to Point connection only  <=====         */
 
             RTVDTAARA  DTAARA(MSSTAT (199 3)) RTNVAR(&CNN)
 
 LOOP1:      IF         COND(&CNN *EQ 'LAN') THEN(GOTO CMDLBL(NTWRK))
 
             CHKOBJ     OBJ(MS2780LIND) OBJTYPE(*LIND)
 
/* Line does not exist - message and exit :                     */
 
             MONMSG     MSGID(CPF9800) EXEC(GOTO CMDLBL(ABEND))
 
/* Line exists - vary devices and transmit data :               */
 
             VRYCFG     CFGOBJ(MS2780DEV) CFGTYPE(*DEV) STATUS(*OFF) +
                        RANGE(*OBJ)
             MONMSG     MSGID(CPF2640)
             VRYCFG     CFGOBJ(MS2780CUD) CFGTYPE(*CTL) STATUS(*OFF) +
                        RANGE(*OBJ)
             MONMSG     MSGID(CPF2640)
             VRYCFG     CFGOBJ(MS2780LIND) CFGTYPE(*LIN) STATUS(*OFF) +
                        RANGE(*OBJ)
             MONMSG     MSGID(CPF2640)
 
             VRYCFG     CFGOBJ(MS2780LIND) CFGTYPE(*LIN) STATUS(*ON) +
                        RANGE(*OBJ)
             MONMSG     MSGID(CPF2640) EXEC(GOTO CMDLBL(RETRY))
             VRYCFG     CFGOBJ(MS2780CUD) CFGTYPE(*CTL) STATUS(*ON) +
                        RANGE(*OBJ)
             MONMSG     MSGID(CPF2640) EXEC(GOTO CMDLBL(RETRY))
             VRYCFG     CFGOBJ(MS2780DEV) CFGTYPE(*DEV) STATUS(*ON) +
                        RANGE(*OBJ)
             MONMSG     MSGID(CPF2640) EXEC(GOTO CMDLBL(RETRY))
 
 
/* Prepare Input File to send data                              */
 
NTWRK:       CHGVAR     VAR(&MODE) VALUE('SEND')
             CHGJOB     SWS(XXXXX000)
 
/* Send notification of Communications startup :                */
 
             SNDPGMMSG  MSG('SWIFT Communication program being +
                          started') TOMSGQ(MRUNQ)
 
/* Retrieve system Id. from SDSTAT                              */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SBSID)
             CHGVAR     VAR(&DMLIB) VALUE(&SBSID *CAT 'DMLIB')
             CHGVAR     VAR(&XLIB)  VALUE(&SBSID *CAT 'XLIB')
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,MSC3001MP1                                     */    /*S01408*/
/**/                                                                  /*S01408*/
 
/** Create Data Queue to control Transmission                      */
 
             DLTDTAQ    DTAQ(&XLIB/MSTCPIP)
             MONMSG     MSGID(CPF2105)
             CRTDTAQ    DTAQ(&XLIB/MSTCPIP) MAXLEN(10) AUT(*ALL)
/*/COPY WNCPYSRC,MSC3001013                                          */
 
/** Setup FTP Input Command File                                   */
 
             CALL       PGM(MS3001) PARM(&MODE)
 
/** IF MS3001 ended in error, send message to inform user          */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&LDA)
 
                        IF COND(&LDA *NE ' '    ) THEN( +
                        SNDPGMMSG MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&LDA) +
                        TOPGMQ(*PRV) TOMSGQ(MOPERQ QSYSOPR))
 
                        GOTO       CMDLBL(ABEND)
             ENDDO
/*/COPY WNCPYSRC,MSC3001014                                          */
 
/* Allow FTP to run in Batch environment and submit transmission program  */
 
             CHGCMD     CMD(QSYS/STRTCPFTP) ALLOW(*ALL)
             MONMSG     MSGID(CPF0000)                              /* 118084 */
 
/************SBMJOB     JOB(MSC3010) JOBD(MBATCH) JOBQ(MSJOBQ) +      /*110242*/
/*************          USER(*JOBD) RTGDTA(MSCFTP) RQSDTA('CALL +     /*110242*/
/*************          MSC3010') */                                  /*110242*/
/************SBMJOB     JOB(MSC3010) JOBD(MBATCH) JOBQ(MSJOBQ) +
                         USER(*JOBD) RTGDTA(MSCFTP) RQSDTA('CALL +
                         MSC3010') INLLIBL(*JOBD)              /*110242 123698*/
/*/COPY WNCPYSRC,MSC3001009                                          */
/************SBMJOB     JOB(MSC3010) JOBD(MBATCH) JOBQ(MSJOBQ) +                          /*CSC023*/
/************             USER(*JOBD) RTGDTA(MSCFTP) RQSDTA('CALL +                       /*CSC023*/
/************             MSC3010') INLLIBL(*JOBD) LANGID(*SYSVAL) +                      /*CSC023*/
/************             CNTRYID(*SYSVAL) CCSID(*SYSVAL)              /*123698*/         /*CSC023*/
             SBMJOB     JOB(MSC3010) JOBD(MBATCH) JOBQ(MSJOBQ) +
                          USER(*JOBD) RTGDTA(MSCFTP) RQSDTA('CALL +
                          MSC3010') INLLIBL(*JOBD) LANGID(*SYSVAL) +
                          CNTRYID(*SYSVAL) CCSID(*SYSVAL) OUTQ(*JOBD)                     /*CSC023*/
 
             CHGVAR     VAR(&TEXT) VALUE('SWIFT Transfer Submitted +
                          - Please wait -      ')
             SNDRCVF    RCDFMT(MS2780S) WAIT(*NO)
 
/* Continue processing ONLY when File has been successfully     */
/* Transferred, otherwise send message and terminate program    */
 
             CALL       PGM(QRCVDTAQ) PARM(MSTCPIP &XLIB &DTQLEN +
                          &RETURN &DTQW)
/*/COPY WNCPYSRC,MSC3001010                                          */
 
             IF         COND(&RETURN *NE 'READY') THEN(DO)
                        CHGVAR     VAR(&TEXT) VALUE('Midas/S.W.I.F.T. Transfer +
                        Program Failure       ')
                        SNDRCVF    RCDFMT(MS2780S) WAIT(*NO)
                        CHGVAR     VAR(&MSG) VALUE('S.W.I.F.T. FILE TRANSFER +
                        FAILURE    - CODE :' *CAT &RETURN)
                        SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ MOPERQ)
                        GOTO CMDLBL(ABEND)
             ENDDO
 
/**          Normal termination - update SWIFT Reference file      */
 
/*/COPY WNCPYSRC,MSC3001005                                          */
             CALL       PGM(MS0203) PARM('T')
/*/COPY WNCPYSRC,MSC3001006                                          */
 
             GOTO       CMDLBL(END)
 
 
/* Errors in vary-on or transmission program - request retry :  */
 
 RETRY:      SNDPGMMSG  MSG('TRANSMISSION FAILED - do you wish to +
                          re-try (Y or N)') TOPGMQ(*EXT) MSGTYPE(*INQ)
             RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) RMV(*YES) MSG(&RPY)
             IF         COND((&RPY *EQ 'Y') *OR (&RPY *EQ 'y')) +
                        THEN(GOTO CMDLBL(LOOP1))
             IF         COND((&RPY *NE 'N') *AND (&RPY *NE 'n')) +
                        THEN(GOTO CMDLBL(RETRY))
 
/* Abnormal end :                                               */
 
/*/COPY WNCPYSRC,MSC3001007                                          */
 ABEND:      CALL       PGM(MS0203) PARM('R')
/*/COPY WNCPYSRC,MSC3001008                                          */
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSG('SWIFT Message Transmission ended +
                          abnormally') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 MCH0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
 
             VRYCFG     CFGOBJ(MS2780LIND) CFGTYPE(*LIN) STATUS(*OFF)
             MONMSG     MSGID(CPF0000)
 
/* Normal end of program :                                      */
 
 END:        DLCOBJ     OBJ((MS0200 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
             DLCOBJ     OBJ((MS4010 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* Display screen message for transmission finished             */
 
             ENDRCV
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&TEXT) VALUE('Processing Complete - +
                          Check Transfer Results -')
             SNDRCVF    RCDFMT(MS2780S) WAIT(*YES)
             MONMSG     MSGID(CPF0000)
             ENDPGM
