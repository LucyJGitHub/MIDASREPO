/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Kill Object Locks in COB')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCKOBJLCB - Kill Object Locks in COB                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/*       Last Amend No. MD021351 *REWRITE  Date 23Jul13              */
/*       Prev Amend No. CCB023             Date 06Aug12              */
/*                      CBF002             Date 04Jul11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      BUG27089           Date 08Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG14338           Date 20Jul07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BG7574             Date 19Jun05              */
/*                      BUG3834 *CREATE    Date 18Jul04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD021351 - Design for Kill object locks                     */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       CBF002 - BF Infrastructure: Backup and Recovery             */
/*       BUG27089 - SCKOBJLCB failed. (RCFMONITOR should be termina- */
/*                  ted prior to killing object locks)               */
/*       BUG14338 - Check Jobs Locking in equation libraries         */
/*       BG7574 - Some jobs take a while to end - put a delay job in */
/*       BUG3834 - New programs created to deal with object locks    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&REPORT)
 
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&RETRYS) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&RETRIED) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)
             DCL        VAR(&KAPUNMNM) TYPE(*CHAR) LEN(3)
             DCL        VAR(&KFILLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KLIBLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOPTLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KINPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTQDLEN) TYPE(*DEC) LEN(5) VALUE(1)
 
             DCL        VAR(&LIBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOGL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
/*/COPY SDCPYSRC,SDSVALDCL                                           */
             DCL        VAR(&REPORT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PIMMED) TYPE(*CHAR) LEN(1) VALUE('N')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYS)
 
             CHGVAR     VAR(&DMLIB) VALUE(&SYS *CAT 'DMLIB')
             CHGVAR     VAR(&DTALIB) VALUE(&SYS *CAT 'DTALIB')
             CHGVAR     VAR(&DPLIB) VALUE(&SYS *CAT 'DPLIB')
             CHGVAR     VAR(&SVALK1) VALUE('KillObjLockCoBRetry')
 
             CHGJOB     SWS(XXXXXX00)
 
             DLTF       FILE(QTEMP/OBJLCK)
             MONMSG     MSGID(CPF0000)
 
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC &SVALK1 &SVAL1 +
                          &SVALK2 &SVAL2 &SVALK3 &SVAL3 &SVALK4 +
                          &SVAL4 &SVALK5 &SVAL5 &SVALK6 &SVAL6 +
                          &SVALK7 &SVAL7 &SVALK8 &SVAL8 &SVALK9 +
                          &SVAL9 &SVALK10 &SVAL10)
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
             CHGVAR     VAR(&RETRYS) VALUE(&SVAL1)
 
/** Terminate report distribution program */
 
             ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF1002) EXEC(DO)
                CALL       PGM(QSNDDTAQ) PARM('FCDTAQ' '*LIBL' +
                               &DTQDLEN 'T')
RETRYFC:
                ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(30)
                MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(RETRYFC))
             ENDDO
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))
 
/** Check if objects in the 'DM','DTA','BF' libraries are locked */
 
             IF         COND(&REPORT *EQ 'N') THEN(DO)
 
                CLRPFM     FILE(SCOBJLPD)
 
/** DSPOBJD objects in DMLIB */
 
                CALL       PGM(SCCOBJLCKR) PARM('*ALL' &DMLIB *FILE +
                             'OBJLCK' 'QTEMP' &PIMMED)
                CPYF       FROMFILE(QTEMP/DSPOBJD) +
                             TOFILE(&DPLIB/SCOBJLPD) MBROPT(*ADD)
 
/** DSPOBJD objects in DTALIB */
 
                CALL       PGM(SCCOBJLCKR) PARM('*ALL' &DTALIB *FILE +
                             'OBJLCK' 'QTEMP' &PIMMED)
                CPYF       FROMFILE(QTEMP/DSPOBJD) +
                             TOFILE(&DPLIB/SCOBJLPD) MBROPT(*ADD)
 
                CHGVAR     VAR(&OPTN) VALUE('*FIRST ')
LOOP:
                CALL       PGM(AOBKLBR0) PARM(&PRTCD &OPTN &PFMT)
                CHGVAR     VAR(&LIBN) VALUE(%SST(&PFMT 1 10))
                CHGVAR     VAR(&ZOGL) VALUE(%SST(&PFMT 111 10))
 
                IF         COND(&PRTCD *EQ '*EMPTY' *OR &PRTCD *EQ +
                             '*EOF' *OR &PRTCD *EQ '*NRF') THEN(DO)
                   CHGVAR     VAR(&OPTN) VALUE('*FREE  ')
                   CALL       PGM(AOBKLBR0) PARM(&PRTCD &OPTN &PFMT)
                   GOTO       CMDLBL(CONT)
                ENDDO
 
                IF         COND(&PRTCD *NE ' ') THEN(DO)
                   CHGVAR     VAR(&OPTN) VALUE('*FREE  ')
                   CALL       PGM(AOBKLBR0) PARM(&PRTCD &OPTN &PFMT)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
/** Do check processing only for Zonal Libraries */
 
                IF         COND(&ZOGL *EQ 'GLOBAL') +
                            THEN(GOTO CMDLBL(LOOP))
 
/** For each record in schemas/libraries file, check for object locks */
 
                CALL       PGM(SCCOBJLCKR) PARM('*ALL' &LIBN *FILE +
                             'OBJLCK' 'QTEMP' &PIMMED)
                CPYF       FROMFILE(QTEMP/DSPOBJD) +
                             TOFILE(&DPLIB/SCOBJLPD) MBROPT(*ADD)
             ENDDO
 
CONT:
             OVRDBF     FILE(DSPOBJD) TOFILE(SCOBJLPD)
             CALL       PGM(SCCOBJLCKJ)
 
             CHGVAR     VAR(&RETRIED) VALUE(0)
 
RETRYKILL:
             CALL       PGM(SCKOBJLCOB) PARM(&REPORT)
 
/** Check if locks have been released */
 
             IF         COND(&RETRYS > &RETRIED *OR &RETRYS = 0) +
                          THEN(DO)
                RTVMBRD    FILE(QTEMP/OBJLCK) NBRCURRCD(&NBRCURRCD)
 
                IF         COND(&RETRYS > &RETRIED *AND &NBRCURRCD > 0) +
                          THEN(DO)
                   CHGVAR     VAR(&RETRIED) VALUE(&RETRIED +1)
                   GOTO       CMDLBL(RETRYKILL)
                ENDDO
 
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
/** Abnormal termination */
 
             SNDPGMMSG  MSG('Kill Object Locks in COB ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
END:
             ENDPGM
