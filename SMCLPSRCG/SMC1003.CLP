/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SM Create SBS for implementation')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1003 - Create implementation subsystem OTU               */
/*                                                                   */
/*       (c) Finastra International Limited 2023                     */
/*                                                                   */
/*       Last Amend No. MD061954 *CREATE   Date 08Oct23              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD061954 - Include restore of reference libraries for aDBU  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PTFUPG &IASPYNSVAL &IASPSVAL)

             DCL        VAR(&IASPYNSVAL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&IASPSVAL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2023')
             DCL        VAR(&PGMED) TYPE(*CHAR) LEN(10) VALUE('SMC1002')
             DCL        VAR(&KEYVR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SNDER) TYPE(*CHAR) LEN(80)
             DCLF       FILE(UPGSVALJ0) ALWNULL(*YES)


             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)

/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
VALIDATE:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(CHECK)
             ENDDO

             IF         COND(&GISVAL *EQ &IASPYNSVAL) THEN(DO)
                IF         COND(&GIVAL *EQ ' ') THEN(DO)
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')
                ENDDO
                ELSE       CMD(DO)
                   CHGVAR     VAR(&IASP_YN) VALUE(&GIVAL)
                ENDDO
             ENDDO

             IF         COND(&GISVAL *EQ &IASPSVAL) THEN(DO)
                IF         COND((&GIVAL *EQ ' ') *AND (&IASP_YN *EQ +
                          'Y')) THEN(DO)
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')
                ENDDO
                ELSE       CMD(DO)
                   CHGVAR     VAR(&IASP) VALUE(&GIVAL)
                ENDDO
             ENDDO

             GOTO       CMDLBL(VALIDATE)
CHECK:

/* Create message queue. */
             CHKOBJ     OBJ(&PTFUPG/SETUP) OBJTYPE(*MSGQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTMSGQ    MSGQ(&PTFUPG/SETUP) TEXT('Midas MSGQ for +
                             implementation') SIZE(10 2)
             ENDDO

/* Create job queue. */
             CHKOBJ     OBJ(&PTFUPG/SMJOBQ) OBJTYPE(*JOBQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTJOBQ    JOBQ(&PTFUPG/SMJOBQ) TEXT('Midas Interactive +
                             JOBQ for implementation') OPRCTL(*NO) +
                             AUTCHK(*DTAAUT) AUT(*CHANGE)
             ENDDO

/* Create second job queue to allow jobs to run simultaneously. */
             CHKOBJ     OBJ(&PTFUPG/SMJOBQNM) OBJTYPE(*JOBQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTJOBQ    JOBQ(&PTFUPG/SMJOBQNM) TEXT('Midas +
                             Interactive JOBQ for implementation +
                             *NOMAX') OPRCTL(*NO) AUTCHK(*DTAAUT) +
                             AUT(*CHANGE)
             ENDDO

/* Create subsystem description. */
             CHKOBJ     OBJ(&PTFUPG/&PTFUPG) OBJTYPE(*SBSD)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTSBSD    SBSD(&PTFUPG/&PTFUPG) POOLS((1 *BASE)) +
                             MAXJOBS(20) TEXT('Midas Subsystem for +
                             implementation')
             ENDDO

/* Create output queue. */
             CHKOBJ     OBJ(&PTFUPG/SETUP) OBJTYPE(*OUTQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTOUTQ    OUTQ(&PTFUPG/SETUP) TEXT('Midas OUTQ for +
                             implementation') DSPDTA(*YES) OPRCTL(*NO) +
                             AUTCHK(*DTAAUT) AUT(*CHANGE)
             ENDDO

/* Create class. */
             CHKOBJ     OBJ(&PTFUPG/SMCLSI) OBJTYPE(*CLS)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTCLS     CLS(&PTFUPG/SMCLSI) RUNPTY(20) +
                             TIMESLICE(2000) PURGE(*YES) TEXT('Midas +
                             Interactive cls for implementation')
             ENDDO
             CHGCLS     CLS(&PTFUPG/SMCLSI) RUNPTY(20) +
                          TIMESLICE(2000)
             MONMSG     MSGID(CPF6801)

/* Add job queue entry. */
             RMVJOBQE   SBSD(&PTFUPG/&PTFUPG) JOBQ(SMJOBQ)
             MONMSG     MSGID(CPF0000)
             ADDJOBQE   SBSD(&PTFUPG/&PTFUPG) JOBQ(&PTFUPG/SMJOBQ) +
                          MAXACT(1) SEQNBR(10)
/* Add second job queue entry. */
             RMVJOBQE   SBSD(&PTFUPG/&PTFUPG) JOBQ(SMJOBQNM)
             MONMSG     MSGID(CPF0000)
             ADDJOBQE   SBSD(&PTFUPG/&PTFUPG) JOBQ(&PTFUPG/SMJOBQNM) +
                          MAXACT(*NOMAX) SEQNBR(20)
/* Add routing entry. */
             RMVRTGE    SBSD(&PTFUPG/&PTFUPG) SEQNBR(99)
             MONMSG     MSGID(CPF0000)
             ADDRTGE    SBSD(&PTFUPG/&PTFUPG) SEQNBR(99) +
                          CMPVAL(*ANY) PGM(QSYS/QCMD) +
                          CLS(&PTFUPG/SMCLSI)

/* Create job description. */
             CHKOBJ     OBJ(&PTFUPG/SETUP) OBJTYPE(*JOBD)
             MONMSG     MSGID(CPF9801) EXEC(DO)

/** If IASP environment */

             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)
             CRTJOBD    JOBD(&PTFUPG/SETUP) JOBQ(&PTFUPG/SMJOBQ) +
                          OUTQ(&PTFUPG/SETUP) TEXT('Midas JOBD for +
                          implementation batch jobs') +
                          INLASPGRP(&IASP) LOG(4 0 *SECLVL) +
                          LOGCLPGM(*YES)
             ENDDO
             ELSE       CMD(DO)
                CRTJOBD    JOBD(&PTFUPG/SETUP) JOBQ(&PTFUPG/SMJOBQ) +
                             OUTQ(&PTFUPG/SETUP) TEXT('Midas JOBD for +
                             implementation batch jobs') LOG(4 0 +
                             *SECLVL) LOGCLPGM(*YES)
             ENDDO
             ENDDO

/* Add workstation entry. */
             RMVWSE     SBSD(&PTFUPG/&PTFUPG) WRKSTNTYPE(*ALL)
             MONMSG     MSGID(CPF0000)
             ADDWSE     SBSD(&PTFUPG/&PTFUPG) WRKSTNTYPE(*ALL) +
                          JOBD(&PTFUPG/SETUP) AT(*ENTER)
/* Start SETUP subsystem. */
             ENDSBS     SBS(&PTFUPG) OPTION(*IMMED)
             MONMSG     MSGID(CPF1054)
             DLYJOB     DLY(10)
             STRSBS     SBSD(&PTFUPG/&PTFUPG)
             MONMSG     MSGID(CPF1010)
             DLYJOB     DLY(10)

             GOTO       CMDLBL(END)

ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC1003') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC1003' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000)

END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
