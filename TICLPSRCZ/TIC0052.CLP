/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Stop/start SD replication in TI/CSCS')       */
/*OVR    CRTPF FILE(QTEMP/SPLF) RCDLEN(112)                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0052 - Ensure Rundate change is passed to TI             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       This program monitors the progress of the TI replication    */
/*       task (prop job) to detect if it has passed the rundate      */
/*       change to TI.  We compare dtaara KCMJRNSEQ (which shows     */
/*       how far through the journal the prop job has read) and      */
/*       the journal sequence of the date change entry in ICJRN.     */
/*       Once the change has been passed, we allow this component    */
/*       to end succesfully.                                         */
/*       The component TIC0011 sequence 4 (Start the TI 'Start of    */
/*       Day' phase) is conditioned on this component having ended.  */
/*       Therefore the date change should always be passed to TI.    */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. 164736  *CREATE    Date 22Dec99              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       164736 - Created to guarantee the rundate update being      */
/*                passed to TI.                                      */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MESSS) TYPE(*CHAR) LEN(100)
             DCL        VAR(&TIWORK) TYPE(*DEC) LEN(2) VALUE(0)
             DCL        VAR(&TIWORK2) TYPE(*DEC) LEN(2) VALUE(0)
             DCL        VAR(&RTNSEQNBR) TYPE(*DEC) LEN(10)
             DCL        VAR(&KCMSEQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KCMNBR) TYPE(*DEC) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NUMBER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&#JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRELIB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SBS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCLF       FILE(SPLF)
 
 
/* Global monitor message and default error message */
 
             CHGVAR     VAR(&MESSS) VALUE('TIC0052 - Rundate +
                          Update to TI terminated abnormally')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('TIC0052 - Retrieve Rundate +
                          change from ICJRN') +
                          TOMSGQ(MRUNQ)
 
 
/* Initialise data and delete any existing spoolfiles. */
 
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NUMBER)
             DLTF       FILE(QTEMP/SPLF)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/SPLF) RCDLEN(112)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
 DLT:        DLTSPLF    FILE(QSYSPRT) JOB(&NUMBER/&USER/&JOB) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF3309 CPF3303) EXEC(GOTO +
                          CMDLBL(PROCEED))
             GOTO       CMDLBL(DLT)
 
 
 /* Set up the info so we know which job to look for. */
 
 PROCEED:    RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRELIB)
             CHGVAR     VAR(&#JOB) VALUE(&PRELIB *TCAT '1PROP')
             CHGVAR     VAR(&#JOB) VALUE('#' *TCAT &#JOB)
 
 
 /* Retrieve subsystem info so we can ascertain if job is running. */
 
             CPYF       FROMFILE(T3PF) TOFILE(*PRINT)
             CPYSPLF    FILE(QSYSPRT) TOFILE(QTEMP/SPLF) +
                          JOB(&NUMBER/&USER/&JOB)
 
 
 /* Read Subsystem info from work file 'SPLF'. */
 
 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ABNOR))
             IF         COND((%SST(&SPLF 20 2)) *EQ &PRELIB) THEN(DO)
                  CHGVAR     VAR(&SBS) VALUE(%SST(&SPLF 26 10))
                  GOTO       CMDLBL(DLT2)
             ENDDO
             GOTO       CMDLBL(READ)
 
 
 /*  Delete any spool files of the type we are about to create. */
 
 DLT2:       DLTSPLF    FILE(QPDSPSBJ) JOB(&NUMBER/&USER/&JOB) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF3309 CPF3303) EXEC(GOTO +
                          CMDLBL(PRINTJOB))
             GOTO       CMDLBL(DLT2)
 
 
 /* Get details of current subsystem jobs. If Subsystem not */
 /* active, delay job for 1 minute. */
 
 WAITSBS:    DLYJOB     DLY(60)
 
 PRINTJOB:   WRKSBSJOB  SBS(&SBS) OUTPUT(*PRINT)
             MONMSG     MSGID(CPF1003) EXEC(GOTO CMDLBL(WAITSBS))
             CPYSPLF    FILE(QPDSPSBJ) TOFILE(QTEMP/SPLF) +
                          JOB(&NUMBER/&USER/&JOB) MBROPT(*ADD)
 
 
 /* Read job info from work file 'SPLF'. */
 
 READJOB:    RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ABNOR))
             IF         COND(((%SST(&SPLF 49 6)) *EQ 'ACTIVE') *AND +
                          (%SST(&SPLF 4 10)) *EQ &#JOB) THEN(GOTO +
                          CMDLBL(PROCEED2))
             IF         COND((%SST(&SPLF 38 5)) *EQ 'E N D') THEN(DO)
                  CHGVAR     VAR(&TIWORK2) VALUE(&TIWORK2 + 1)
                  IF         COND(&TIWORK2 *GE 30) THEN(DO)
                  GOTO       CMDLBL(TIMEOUT)
                  ENDDO
                  DLYJOB     DLY(60)
                  GOTO       CMDLBL(DLT2)
                  ENDDO
             GOTO       CMDLBL(READJOB)
 
 
/* Retrieve the journal entry that reflects the date change made by */
/* SCC0411. */
 
 PROCEED2:   RTVJRNE    JRN(ICJRN) FILE((SDBANKPD)) JRNCDE((R)) +
                           ENTTYP(UP) JOB(SCC0411) PGM(SD1030) +
                           RTNSEQNBR(&RTNSEQNBR)
 
/* If no journal entry found then rundate is not updated in Midas */
/* we have an error. */
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&MESSS) VALUE('TIC0052 - Rundate Update +
                          to TI terminated abnormally.  Error +
                          retrieving journal entry.')
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/*  Retrieve the data area that dictates how far through the journal */
/*  the Propogation task has read and passed updates to TI.  Once */
/*  the Rundate change entry in ICJRN is passed, allow the component */
/*  to complete normally. */
 
 START:      RTVDTAARA  DTAARA(KCMJRNSEQ (1 10)) RTNVAR(&KCMSEQ)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&MESSS) VALUE('TIC0052 - Rundate Update +
                          to TI terminated abnormally.  DTAARAA KCM +
                          JRNSEQ not found')
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGVAR     VAR(&KCMNBR) VALUE(&KCMSEQ)
 
 
/* If Prop job has passed the rundate change in ICJRN, assume the */
/* date change has been passed to TI. Read remainder of file records */
/* so delete of file is possible. */
 
             IF         COND(&KCMNBR *GE &RTNSEQNBR) THEN(DO)
 ENDFILE:    RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(DLTCMP))
             GOTO       CMDLBL(ENDFILE)
 DLTCMP:     DLTF       FILE(QTEMP/SPLF)
             GOTO       CMDLBL(END)
             ENDDO
 
 
/* If the date change has not yet been passed to TI, delay the */
/* component until it has. */
 
             DLYJOB     DLY(60)
             CHGVAR     VAR(&TIWORK) VALUE(&TIWORK + 1)
 
 
/* If the date change has not been passed within 60 minutes, then fail */
/* this component. */
 
             IF         COND(&TIWORK *GE 60) THEN(DO)
TIMEOUT:     CHGVAR     VAR(&MESSS) VALUE('TIC0052 - Rundate Update +
                          to TI terminated abnormally.  Timed Out')
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Re-read the data area to see of the Prop job has read further. */
 
             GOTO       CMDLBL(START)
 
 ABNOR:
/* Abnormal termination  */
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MESSS) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
 
