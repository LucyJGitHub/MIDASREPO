/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Stop and start Midas/TI batch jobs')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0050 - Stop & Start the Midas/TI batch jobs              */
/*                                                                   */
/*       Called by SCMENUF and COB                                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 02Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      171248             Date 14DEC99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      139756             Date 24Aug98              */
/*                      CTI001  *CREATE    Date 28AUG97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       171248 - Change TI0350 with 'STOP ', but with leaving the   */
/*                rest information as it is.                         */
/*       139756 - Job being submitted without ML overrides.          */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&ACTION)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('TIC0050 - Stop & Start the Midas TI +
                          batch jobs') TOMSGQ(MRUNQ)
 
             IF         COND(&ACTION *EQ 'STOP') THEN(DO)
/*  Change data area TI0340 to STOP */
             ALCOBJ     OBJ((TI0340 *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             SNDPGMMSG  MSG('Cannot allocate data area TI0340') +
                          TOMSGQ(MOPERQ)
             ENDJOB     JOB(TIJRNENT)
             SNDPGMMSG  MSG('Ending job TIJRNENT') TOMSGQ(MOPERQ)
             DLYJOB     DLY(30)
             ALCOBJ     OBJ((TI0340 *DTAARA *EXCL)) WAIT(0)
             ENDDO
/************CHGDTAARA  DTAARA(TI0340) VALUE('STOP')*********/                            /*171248*/
             CHGDTAARA  DTAARA(TI0340 (1 5)) VALUE('STOP ')                               /*171248*/
             DLCOBJ     OBJ((TI0340 *DTAARA *EXCL))
 
/*  Change data area TI0350 to STOP */
             ALCOBJ     OBJ((TI0350 *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             SNDPGMMSG  MSG('Cannot allocate data area TI0350') +
                          TOMSGQ(MOPERQ)
             ENDJOB     JOB(TISHDPST)
             SNDPGMMSG  MSG('Ending job TISHDPST') TOMSGQ(MOPERQ)
             DLYJOB     DLY(30)
             ALCOBJ     OBJ((TI0350 *DTAARA *EXCL)) WAIT(0)
             ENDDO
/************CHGDTAARA  DTAARA(TI0350) VALUE('STOP')*********/                            /*171248*/
             CHGDTAARA  DTAARA(TI0350 (1 5)) VALUE('STOP ')                               /*171248*/
             DLCOBJ     OBJ((TI0350 *DTAARA *EXCL))
             GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(&ACTION *EQ 'START') THEN(DO)
/*  If data area TIJRNENT is locked, the job TIJRNENT has been */
/*  submitted before.                                          */
             ALCOBJ     OBJ((TIJRNENT *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(TISHDPST))
             DLCOBJ     OBJ((TIJRNENT *DTAARA *EXCL))
/*  Change data area TI0340 to START */
             ALCOBJ     OBJ((TI0340 *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             SNDPGMMSG  MSG('Cannot allocate data area TI0340') +
                          TOMSGQ(MOPERQ)
             GOTO ABNOR
             ENDDO
             CHGDTAARA  DTAARA(TI0340) VALUE('START')
             DLCOBJ     OBJ((TI0340 *DTAARA *EXCL))
/************SBMJOB     CMD(CALL PGM(TIC0340)) JOB(TIJRNENT) +     */ /*139756*/
/************             JOBD(TIJOBD) JOBQ(TIJOBQ)                */ /*139756*/
/************SBMJOB     CMD(CALL PGM(MLC0000) PARM('TIC0340' ' ' ' ' +                    /*CPK014*/
/************             ' ' ' ' ' ')) JOB(TIJRNENT) JOBD(TIJOBD) +                      /*CPK014*/
/************             JOBQ(TIJOBQ)                                /*139756*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MLC0000) PARM('TIC0340' ' ' ' ' +                    /*CSC023*/
/************             ' ' ' ' ' ')) JOB(TIJRNENT) JOBD(TIJOBD) +                      /*CSC023*/
/************             JOBQ(TIJOBQ) USER(*JOBD)                             /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(MLC0000) PARM('TIC0340' ' ' ' ' +
                          ' ' ' ' ' ')) JOB(TIJRNENT) JOBD(TIJOBD) +
                          JOBQ(TIJOBQ) USER(*JOBD) OUTQ(*JOBD)                            /*CSC023*/
 
/*  If data area TISHDPST is locked, the job TISHDPST has been */
/*  submitted before.                                          */
 TISHDPST:   ALCOBJ     OBJ((TISHDPST *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(END))
             DLCOBJ     OBJ((TISHDPST *DTAARA *EXCL))
/*  Change data area TI0350 to START */
             ALCOBJ     OBJ((TI0350 *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             SNDPGMMSG  MSG('Cannot allocate data area TI0350') +
                          TOMSGQ(MOPERQ)
             GOTO ABNOR
             ENDDO
             CHGDTAARA  DTAARA(TI0350) VALUE('START')
             DLCOBJ     OBJ((TI0350 *DTAARA *EXCL))
/************SBMJOB     CMD(CALL PGM(TIC0350)) JOB(TISHDPST) +     */ /*139756*/
/************             JOBD(TIJOBD) JOBQ(TIJOBQ)                */ /*139756*/
/************SBMJOB     CMD(CALL PGM(MLC0000) PARM('TIC0350' ' ' ' ' +                    /*CPK014*/
/************             ' ' ' ' ' ')) JOB(TISHDPST) JOBD(TIJOBD) +                      /*CPK014*/
/************             JOBQ(TIJOBQ)                                /*139756*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MLC0000) PARM('TIC0350' ' ' ' ' +                    /*CSC023*/
/************             ' ' ' ' ' ')) JOB(TISHDPST) JOBD(TIJOBD) +                      /*CSC023*/
/************             JOBQ(TIJOBQ) USER(*JOBD)                             /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(MLC0000) PARM('TIC0350' ' ' ' ' +
                          ' ' ' ' ' ')) JOB(TISHDPST) JOBD(TIJOBD) +
                          JOBQ(TIJOBQ) USER(*JOBD) OUTQ(*JOBD)                            /*CSC023*/
 
             GOTO       CMDLBL(END)
             ENDDO
 
/* Abnormal termination  */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&MSG) VALUE('TIC0050 - Stop & Start the +
                          Midas/TI batch jobs terminated abnormally')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
