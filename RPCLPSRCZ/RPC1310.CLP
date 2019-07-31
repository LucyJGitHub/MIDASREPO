/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB start Midas/TOF MQSeries Q. triggering')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1310 - Start Midas/TOF MQSeries Queue triggering.        */
/*                                                                   */
/*       Function: this CLP program submits one trigger server for   */
/*                 each Initiation Queue that was defined in Control */
/*                 File RPINIQPD with triggering type "Q" and is     */
/*                 flagged as active.                                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Sbs)           TYPE(*CHAR) LEN(2)
             DCL        VAR(&DtaAraLib)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&Jobd)          TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobdLib)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&Jobq)          TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobqLib)       TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&NbrInitQ)      TYPE(*DEC)  LEN(10 0) +
                 /* Number of Initiation Queues defind in Control File. */
             DCL        VAR(&SavSeqNbr)     TYPE(*CHAR) LEN(2) +
                 /* Sequence Number used to create Trigger Data Area. */
             DCL        VAR(&NumDtaara)     TYPE(*DEC)  LEN(2 0) +
                 /* Number of Data Areas. */
             DCL        VAR(&SeqNumber)     TYPE(*CHAR) LEN(2) +
                 /* Sequence Number of Data Area. */
             DCL        VAR(&Dtaara)        TYPE(*CHAR) LEN(10) +
                 /* Name of Trigger Data Area. */
             DCL        VAR(&Text)          TYPE(*CHAR) LEN(50) +
                 /* Trigger Data Area Text Description. */
 
             DCL        VAR(&RunBefore)     TYPE(*CHAR) LEN(1) +
                 /* Work field used to run same command two times. */
             DCL        VAR(&InitQueue)     TYPE(*CHAR) LEN(48) +
                 /* Name of Initiation Queue from Trigger Data Area. */
 
             DCL        VAR(&JobName)       TYPE(*CHAR) LEN(10) +
                 /* Name of Trigger Server job. */
 
             DCL        VAR(&Rqsdta)        TYPE(*CHAR) LEN(128) +
                 /* Work field used to define command to be submitted.  */
             DCL        VAR(&Msgdta)        TYPE(*CHAR) LEN(128) +
                 /* Message data field values. */
 
             DCL        VAR(&STRING) TYPE(*CHAR) LEN(48)
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&PATTERN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&TRANSLATE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRIM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WILD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3 0)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*---------------------------------------*/
/*  Initiation Queues File declaration.  */
/*---------------------------------------*/
 
             DCLF       FILE(RPINIQL2) RCDFMT(RPINIQD0)
 
/*-------------------------------------------------------------------*/
/*  Global monitor message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Allocate General Trigger Data Area to avoid more than one        */
/*  program running at the same time.                                */
/*-------------------------------------------------------------------*/
 
             ALCOBJ     OBJ((RPTRG *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ENDPGM))
 
/*-------------------------------------------------------------------*/
/*  Retrieve Midas System Id.                                        */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&Sbs)
 
/*-------------------------------------------------------------------*/
/*  Set up common parameters, from values stored in Meridian         */
/*  Triggering Data Area RPTRG.                                      */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(RPTRG (1 10))  RTNVAR(&DtaAraLib)
             RTVDTAARA  DTAARA(RPTRG (11 10)) RTNVAR(&Jobd)
             RTVDTAARA  DTAARA(RPTRG (21 10)) RTNVAR(&JobdLib)
             RTVDTAARA  DTAARA(RPTRG (31 10)) RTNVAR(&Jobq)
             RTVDTAARA  DTAARA(RPTRG (41 10)) RTNVAR(&JobqLib)
 
/*-------------------------------------------------------------------*/
/*  Retrieve number of defined Initiation Queues.                    */
/*-------------------------------------------------------------------*/
 
             RTVMBRD    FILE(RPINIQL2) NBRCURRCD(&NbrInitQ)
 
/*-------------------------------------------------------------------*/
/*  Process all Initiation Queues to be served.                      */
/*-------------------------------------------------------------------*/
 
 RCVF:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
 
             CHGVAR     VAR(&STRING)  VALUE(&ININIQ)
             CHGVAR     VAR(&STRLEN) VALUE(48)
             CHGVAR     VAR(&STRPOS) VALUE(1)
             CHGVAR     VAR(&PATTERN) VALUE('XX')
             CHGVAR     VAR(&PATLEN) VALUE(2)
             CHGVAR     VAR(&RESULT) VALUE(0)
 
             CALL       PGM(QCLSCAN) PARM(&STRING &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
 
                   /* Replace xx system name by Midas system name */
             IF         COND(&RESULT > 1) THEN(DO)
                   CHGVAR     VAR(%SST(&ININIQ &RESULT 2)) VALUE(&SBS)
             ENDDO
 
             CHGVAR     VAR(&SavSeqNbr) VALUE(' ')
             CHGVAR     VAR(&NumDtaara) VALUE(0)
 
 CHKDTAARA:  CHGVAR     VAR(&NumDtaAra) VALUE(&NumDtaara + 1)
             IF         COND(&NumDtaAra > &NbrInitQ) THEN(DO)
                   IF         COND(&SavSeqNbr = ' ') THEN(DO)
                        CHGVAR     VAR(&MSGDTA) +
                                     VALUE('No more available sequence number +
                                            to create Trigger Data Area for   +
                                            Initiation Queue' *BCAT &ININIQ)
                        SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                                     TOMSGQ(MRUNQ MOPERQ)
                        GOTO       CMDLBL(ABNOR)
                   ENDDO
                   CHGVAR     VAR(&SeqNumber) VALUE(&SavSeqNbr)
                   CHGVAR     VAR(&Dtaara)    VALUE('RPTRG' *CAT &SeqNumber)
                   CHGVAR     VAR(&Text)      VALUE('Midas PB Meridian Trigger +
                                                     Server' *BCAT &SeqNumber +
                                                     *TCAT ' Data Area.')
                   CRTDTAARA  DTAARA(&DTAARALIB/&DTAARA) TYPE(*CHAR) +
                              LEN(49) VALUE(&ININIQ *CAT &INCMTC) +
                              TEXT(&TEXT) AUT(*ALL)
                   GOTO       CMDLBL(JOBNAME)
             ENDDO
 
             CHGVAR     VAR(&SeqNumber) VALUE(&NumDtaAra)
 
             CHGVAR     VAR(&Dtaara)    VALUE('RPTRG' *CAT &SeqNumber)
 
/*-------------------------------------------------------------------*/
/*  Check the existence of the data area.                            */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&RunBefore) VALUE('N')
CHKOBJ:      CHKOBJ     OBJ(&DtaAra) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                   IF         COND(&SavSeqNbr = ' ') THEN(DO)
                         CHGVAR     VAR(&SavSeqNbr)  VALUE(&SeqNumber)
                   ENDDO
                   GOTO       CMDLBL(CHKDTAARA)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Data Area fits Initiation Queue.                        */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(&Dtaara (1 48)) RTNVAR(&InitQueue)
             IF         COND(&InitQueue *NE &ININIQ) THEN(GOTO +
                          CMDLBL(CHKDTAARA))
 
/*-------------------------------------------------------------------*/
/*  Allocate the Trigger Server data area to determine if the        */
/*  Trigger Server is already active. Only start it if it is not.    */
/*  If the initial allocation was successful:                        */
/*       - deallocate the data area.                                 */
/*       - delay for 5 seconds and retry the allocation.             */
/*       - only perform the submit if the second allocation works,   */
/*  in case the job is already submitted but not yet active.         */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&RunBefore) VALUE('N')
ALCOBJ:      ALCOBJ     OBJ((&Dtaara *DTAARA *EXCLRD)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(RCVF))
 
             DLCOBJ     OBJ((&Dtaara *DTAARA *EXCLRD))
 
             IF         COND(&Runbefore *EQ 'N') THEN(DO)
                  CHGVAR     VAR(&RunBefore) VALUE('Y')
                  DLYJOB     DLY(5)
                  GOTO       CMDLBL(ALCOBJ)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Set up parameters for SBMJOB command.                            */
/*-------------------------------------------------------------------*/
 
JOBNAME:     CHGVAR     VAR(&Jobname)   VALUE('RPTRGSRV' *CAT &SeqNumber)
             CHGVAR     VAR(&RQSDTA) VALUE('RPTRGSRV  INITQUEUE(' *CAT +
                                            &ININIQ *CAT ') COMMITCTL(' +
                                            *CAT &INCMTC *CAT ')')
/*-------------------------------------------------------------------*/
/*  Submit the Trigger Server.                                       */
/*-------------------------------------------------------------------*/
 
/************SBMJOB     JOB(&JOBNAME) JOBD(&JOBD) +                                       /*CSC023*/
/************             JOBQ(&JOBQLIB/&JOBQ) USER(*JOBD) +                              /*CSC023*/
/************             RQSDTA(&RQSDTA) INLLIBL(*JOBD)                                  /*CSC023*/
 
             SBMJOB     JOB(&JOBNAME) JOBD(&JOBD) +
                          JOBQ(&JOBQLIB/&JOBQ) USER(*JOBD) +
                          RQSDTA(&RQSDTA) INLLIBL(*JOBD) OUTQ(*JOBD)                      /*CSC023*/
 
             GOTO       CMDLBL(RCVF)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) +
                          VALUE('RPC1310 - Start Midas/TOF MQSeries queue +
                                 triggering - ended abnormally. See job log')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             /* Deallocate the data area. */
             DLCOBJ     OBJ((RPTRG *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
