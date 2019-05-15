/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Main Feedback Job')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC3702  -  Main Feedback Processing                        */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 248399             Date 11Jun07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG7700            Date 24Jun05              */
/*                      231737             Date 27Jan05              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CCG015  *CREATE    Date 06Mar02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       248399 - Warning with wrong number of Item awaiting         */
/*                feedback.                                          */
/*       BUG7700- Send message with msgid to MOPERQ so that          */
/*                Tivoli monitoring can detect it.                   */
/*       231737 - Force FTP for first run.                           */
/*       CCG015 - Correspondence Manager (Phase 1)                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/* Declare variables */
/**/
/* Entry parameters */
/* ---------------- */
/**/
       DCL  VAR(&PARM1) TYPE(*CHAR) LEN(200)
       DCL  VAR(&PARM2) TYPE(*CHAR) LEN(200)
       DCL  VAR(&PARM3) TYPE(*CHAR) LEN(200)
       DCL  VAR(&PARM4) TYPE(*CHAR) LEN(200)
       DCL  VAR(&PARM5) TYPE(*CHAR) LEN(200)
/**/
/* Parameters for QRCVDTAQ */
/* ----------------------- */
/**/
       DCL  VAR(&DQNAME) TYPE(*CHAR) LEN(10)  VALUE(CGFEEDQ)
       DCL  VAR(&DQLIB)  TYPE(*CHAR) LEN(10)  VALUE(*LIBL)
       DCL  VAR(&DQLEN)  TYPE(*DEC)  LEN(5 0) VALUE(10)
       DCL  VAR(&DQDATA) TYPE(*CHAR) LEN(10)
       DCL  VAR(&DQWAIT) TYPE(*DEC)  LEN(5 0) VALUE(0)
/**/
/* Parameters for CG3703 (Correspondence Explorer) */
/* ----------------------------------------------- */
/**/
       DCL  VAR(&ERRITEMS) TYPE(*CHAR) LEN(5)
/**/
/* Parameters for CG3705  (Midas CG Extract CTL File Name */
/* ------------------------------------------------------ */
/**/
       DCL  VAR(&RTNPARM) TYPE(*CHAR) LEN(10)
/**/
/* Parameters for CG3706 (Read FTP Control file PF/CGOUTFPD) */
/* --------------------------------------------------------- */
/**/
       DCL  VAR(&LOGFILE) TYPE(*CHAR) LEN(30)
       DCL  VAR(&CTLFILE) TYPE(*CHAR) LEN(30)
/**/
/* Parameters for CG3707 (Process Feedback Log File) */
/* ------------------------------------------------- */
/* (NOTE: Uses &LOGFILE and &RTNCODE as parameter)   */
/**/
/* Parameters for CG3709 (FTP Feedback Patterns Analyser) */
/* ------------------------------------------------------ */
/**/
       DCL  VAR(&ACTION) TYPE(*CHAR) LEN(10)
       DCL  VAR(&STATUS) TYPE(*CHAR) LEN(10)
/**/
/* Parameters for CGC3703 (CM Prepare FTP Work Files */
/* ------------------------------------------------- */
/* (NOTE: Uses &ACTION and &RTNCODE as parameter)    */
/**/
/**/
/* Parameters for CGC3704 (FTP Feedback Command Generator) */
/* ------------------------------------------------------- */
/**/
       DCL  VAR(&ACTPARM) TYPE(*CHAR) LEN(10)
       DCL  VAR(&JOBPARM) TYPE(*CHAR) LEN(30)
       DCL  VAR(&HSTPARM) TYPE(*CHAR) LEN(30)
       DCL  VAR(&FRQPARM) TYPE(*DEC)  LEN(5 0)
/**/
/* Parameters for CGC3705 (Initiate FTP Session) */
/* --------------------------------------------- */
/**/
       DCL  VAR(&HSTPARM) TYPE(*CHAR) LEN(30)
/**/
/* Parameters for CG3707 (Process Feedback Log File) */
/* ------------------------------------------------- */
/* (NOTE: Uses &LOGFILE and &RTNCODE as parameter)   */
/**/
/* Other work variables */
/* -------------------- */
/**/
       DCL  VAR(&RTNCODE)  TYPE(*CHAR) LEN(10)
       DCL  VAR(&FIRSTRUN) TYPE(*CHAR) LEN(1) VALUE('Y')
/**/
/* Global Monitor Message */
/**/
       MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
       CHGJOB  SWS(XXXXX000)
       STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) CMTSCOPE(*JOB)
/**/
/*-------------------------------------------------------------------*/
/* PREPARE FTP WORKFILES                                             */
/*-------------------------------------------------------------------*/
/**/
/* Create copies of FTP work files in QTEMP library */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*CREATE   ')
 
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
 
             IF         COND(&RTNCODE *NE '          ') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Clear FTP Feedback Control file */
/**/
             CLRPFM     FILE(CGOUTFPD)
/**/
/* Clear dataqueue before commencing Feedback job */
/**/
       CALL       PGM(QCLRDTAQ) PARM(&DQNAME &DQLIB)
/**/
 LISTFBACK:
/**/
/* Read what's currently written in the data queue. */
/**/
 
       CALL       PGM(QRCVDTAQ) PARM(&DQNAME &DQLIB &DQLEN +
                     &DQDATA &DQWAIT)
/**/
/* The job will end if it receive '*END' on the dataqueue. */
/**/
       IF         COND(&DQDATA = '*END      ') +
                     THEN(GOTO CMDLBL(RELEASE))
 
/*-------------------------------------------------------------------*/
/* Call CORRESPONDENCE EXPLORER to scan log files for transmitted    */
/* streamfiles awaiting feedback.                                    */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&RTNCODE) VALUE('          ')
             CHGVAR     VAR(&ERRITEMS) VALUE('     ')
 
             CALL       PGM(CG3703) PARM(&RTNCODE &ERRITEMS)
 
/**/
/* If &ERRITEMS is non-blank, send a warning message to QSYSOPR */
/* and MOPERQ indicating that ITEMS IN ERROR are found.         */
/**/
             IF         COND(&ERRITEMS *NE '     ') THEN(DO)
/*           SNDMSG     MSG('*** WARNING *** Correspondence Manager +
                          : You have ' *BCAT &ERRITEMS *BCAT 'Items +
                          awaiting feedback from FormsMaster. +
                          Please check PC Print Server.') +
                          TOMSGQ(MOPERQ QSYSOPR) */                                 /*248399*/
             ENDDO
 
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
             IF         COND(&FIRSTRUN = 'Y') THEN(DO)                /*231737*/
             CHGVAR     VAR(&FIRSTRUN) VALUE('N')                     /*231737*/
             ENDDO                                                    /*231737*/
             ELSE       CMD(DO)                                       /*231737*/
             IF         COND(&RTNCODE = '*NOFILES') THEN(GOTO +
                          CMDLBL(RELEASE))
             ENDDO                                                    /*231737*/
 
/*-------------------------------------------------------------------*/
/* FTP FEEDBACK SESSION 1 - LIST .CTL FILES                          */
/*-------------------------------------------------------------------*/
/**/
/* Override FTP work files */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*OVERRIDE')
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
             CLRPFM     FILE(QTEMP/CGFTPCPD)
/**/
/* Format FTP LIST commands */
/**/
             CHGVAR     VAR(&ACTPARM) VALUE('*LIST     ')
 
             CALL       PGM(CGC3704) PARM(&ACTPARM &JOBPARM &HSTPARM +
                          &FRQPARM &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Delete overrides  */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*DLTOVR')
 
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* FTP session  - LIST */
/**/
             CALL       PGM(CGC3705) PARM(&HSTPARM &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Override FTP work files */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*OVERRIDE')
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Analyse FTP Log patterns */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*LIST     ')
 
             CALL       PGM(CG3709) PARM(&ACTION &RTNCODE &STATUS)
 
/* Undefined error encountered */
 
             IF         COND(&STATUS = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
/* Problem with logging in */
 
             IF         COND(&STATUS = '*LOGINFAIL') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
/* Problem with host name */
 
             IF         COND(&STATUS = '*UNKWNHOST') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
/* Problem with path of destination directory */
 
             IF         COND(&STATUS = '*UNKWNPATH') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Delete overrides  */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*DLTOVR')
 
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
/*----------------------------------------------------------------*/
/* Call program to extract .CTL files from the FTP log file. This */
/* will scan through CGFTPLPD and output to CGOUTFPD              */
/*----------------------------------------------------------------*/
/**/
/* Override FTP work files */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*OVERRIDE')
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Call program to extract .CTL files from FTP log. */
/**/
             CHGVAR     VAR(&RTNPARM) VALUE(' ')
             CALL       PGM(CG3705) PARM(&RTNPARM)
/**/
/* If error during processing of FTP LS log record. */
/**/
             IF         COND(&RTNPARM = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* If no .CTL is extracted, delay the job then run the   */
/* Correspondence Explorer and do FTP LIST again.        */
/**/
             IF         COND(&RTNPARM = '*NORECORD') THEN(GOTO +
                          CMDLBL(DELAYTAG))
/**/
/* Delete overrides  */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*DLTOVR')
 
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/*-------------------------------------------------------------------*/
/*           FTP FEEDBACK SESSION 2 - GET .DAT LOG FILES             */
/*-------------------------------------------------------------------*/
 GETFBACK:
/**/
/* Call program to scan through Feedback control file :         */
/*   NOTE: Name of .LOG and .CTL file name to be processed will */
/*         be passed back from CG3706.                          */
/**/
             CHGVAR     VAR(&LOGFILE) VALUE(' ')
             CHGVAR     VAR(&CTLFILE) VALUE(' ')
             CHGVAR     VAR(&RTNCODE) VALUE(' ')
             CALL       PGM(CG3706) PARM(&LOGFILE &CTLFILE &RTNCODE)
 
/* If no record is read from PF/CGOUTFPD, all .CTL records must  */
/* have been processed at this point already. Delay job and run  */
/* Correspondence Explorer again to check if there are more      */
/* Items sent awaiting feedback                                  */
 
             IF         COND(&RTNCODE = '*NORECORD ') THEN(GOTO +
                          CMDLBL(DELAYTAG))
 
/* Problem encountered */
 
             IF         COND(&RTNCODE = '*ERROR    ') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Override FTP work files */
/**/
 
             CHGVAR     VAR(&ACTION) VALUE('*OVERRIDE')
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
             CLRPFM     FILE(QTEMP/CGFTPCPD)
 
/**/
/* Format FTP GET commands */
/**/
             CHGVAR     VAR(&ACTPARM) VALUE('*GET      ')
             CHGVAR     VAR(&JOBPARM) VALUE(&LOGFILE)
             CHGVAR     VAR(&RTNCODE) VALUE(' ')
 
             CALL       PGM(CGC3704) PARM(&ACTPARM &JOBPARM &HSTPARM +
                          &FRQPARM &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Delete overrides  */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*DLTOVR')
 
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* FTP session  - GET */
/**/
             CALL       PGM(CGC3705) PARM(&HSTPARM &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Override FTP work files */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*OVERRIDE')
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Analyse FTP Log patterns */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*GET      ')
 
             CALL       PGM(CG3709) PARM(&ACTION &RTNCODE &STATUS)
 
/* Undefined error encountered */
 
             IF         COND(&STATUS = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
/* Problem with logging in */
 
             IF         COND(&STATUS = '*LOGINFAIL') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
/* Problem with host name */
 
             IF         COND(&STATUS = '*UNKWNHOST') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
/* Problem with path of destination directory */
 
             IF         COND(&STATUS = '*UNKWNPATH') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Delete overrides  */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*DLTOVR')
 
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/*-------------------------------------------------------------------*/
/* PROCESS .LOG FILE RETRIEVED                                       */
/*-------------------------------------------------------------------*/
/* Call program to process Feedback Log file */
 
             CALL       PGM(CG3707) PARM(&LOGFILE &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/*-------------------------------------------------------------------*/
/* FTP FEEDBACK SESSION 3 - DEL .CTL LOG FILES                       */
/*-------------------------------------------------------------------*/
/**/
/* Override FTP work files */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*OVERRIDE')
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
             CLRPFM     FILE(QTEMP/CGFTPCPD)
/**/
/* Format FTP DELETE commands */
/**/
             CHGVAR     VAR(&ACTPARM) VALUE('*DELETE   ')
             CHGVAR     VAR(&JOBPARM) VALUE(&CTLFILE)
             CHGVAR     VAR(&RTNCODE) VALUE(' ')
 
             CALL       PGM(CGC3704) PARM(&ACTPARM &JOBPARM &HSTPARM +
                          &FRQPARM &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Delete overrides  */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*DLTOVR')
 
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* FTP session  - DELETE */
/**/
             CALL       PGM(CGC3705) PARM(&HSTPARM &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Override FTP work files */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*OVERRIDE')
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Analyse FTP Log patterns */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*DELETE   ')
 
             CALL       PGM(CG3709) PARM(&ACTION &RTNCODE &STATUS)
 
/* Undefined error encountered */
 
             IF         COND(&STATUS = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
/* Problem with logging in */
 
             IF         COND(&STATUS = '*LOGINFAIL') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
/* Problem with host name */
 
             IF         COND(&STATUS = '*UNKWNHOST') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
/* Problem with path of destination directory */
 
             IF         COND(&STATUS = '*UNKWNPATH') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Delete overrides  */
/**/
             CHGVAR     VAR(&ACTION) VALUE('*DLTOVR')
 
             CALL       PGM(CGC3703) PARM(&ACTION &RTNCODE)
             IF         COND(&RTNCODE = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Retrieve next .CTL file to be processed from CGOUTFPD */
/**/
             GOTO GETFBACK
/**/
 DELAYTAG:
/**/
/* Delay job as per Polling Frequency defined in ICD before */
/* running Correspondence Explorer again.                   */
/**/
             DLYJOB     DLY(&FRQPARM)
 
             GOTO       CMDLBL(LISTFBACK)
 
/**/
/* Abnormal termination processing */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC3702 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/**/                                                                                     /*BUG7700*/
             SNDPGMMSG  MSGID(CGL0002) MSGF(GBCGUSRMSG) +
                          TOMSGQ(MOPERQ MRUNQ)                                           /*BUG7700*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*BUG7700*/
/**/                                                                                     /*BUG7700*/
/* Unlock ICD record, clear data area before ending the job */
/**/
 RELEASE:
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(CGFEED) VALUE(' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             IF         COND(&ERRITEMS *NE '     ') THEN(DO)                              /*248399*/
             SNDMSG     MSG('*** WARNING *** Correspondence Manager +
                          : You have ' *BCAT &ERRITEMS *BCAT 'Items +
                          awaiting feedback from FormsMaster. +
                          Please check PC Print Server.') +
                          TOMSGQ(MOPERQ)                                                  /*248399*/
             ENDDO                                                                        /*248399*/
 
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/* */
             ENDPGM
