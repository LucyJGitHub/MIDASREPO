/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG FTP Transfer')                               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC3607  -  FTP Transfer                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. CSD101             Date 07Dec18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG7700            Date 24Jun05              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CCG015  *CREATE    Date 10Mar02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD101 - Password Encryption                                */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG7700- Send message with msgid to MOPERQ so that          */
/*                Tivoli monitoring can detect it.                   */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
/* */
/* Declare variables */
/* */
/* Parameters for QRCVDTAQ */
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10) VALUE(CGFTPJQ)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) VALUE(*LIBL)
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(5 0) VALUE(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0) VALUE(0)
/* */
/* Parameters for CG3612 */
             DCL        VAR(&SRCDIR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DSTDIR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(750)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(20)
/*********   DCL        VAR(&PSWRD) TYPE(*CHAR) LEN(20) */                                /*CSD101*/
             DCL        VAR(&PSWRD) TYPE(*CHAR) LEN(128)                                  /*CSD101*/
             DCL        VAR(&HOST) TYPE(*CHAR) LEN(30)
/* */
/* Parameters for CG3630 */
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(10) +
                          VALUE('          ')
             DCL        VAR(&STREAM) TYPE(*CHAR) LEN(20)
/* */
/* Parameters for CGC3701 (FEEDBACK process) */
             DCL        VAR(&RTNPARM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACTPARM) TYPE(*CHAR) LEN(10)
/* */
/* Entry parameters */
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(200)
/*/COPY WNCPYSRC,CGH00003                                            */
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
             CHGJOB     SWS(XXXXX000)
                   STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
/*/COPY WNCPYSRC,CGH00005                                            */
/**/
/* Clear dataqueue before commencing FTP job */
/**/
             CALL       PGM(QCLRDTAQ) PARM(&NAME &LIB)

/**/
/* Create copies of FTP work files in QTEMP library */
/* + Override */
             CHGVAR     VAR(&ACTION) VALUE('*CREATE   ')
             CALL       PGM(CGC3703) PARM(&ACTION &RETURN)
             IF         COND(&RETURN *NE ' ') THEN(GOTO +
                          CMDLBL(ABNORMAL))

             CHGVAR     VAR(&ACTION) VALUE('*OVERRIDE ')
             CALL       PGM(CGC3703) PARM(&ACTION &RETURN)
             IF         COND(&RETURN *NE ' ') THEN(GOTO +
                          CMDLBL(ABNORMAL))

/**/
/* The job will end when it has received '*END' on the dataqueue.   */
/* i.e. it has been cancelled via the midas menu item option CFTP   */
/**/
             LOOP:
             CALL       PGM(QRCVDTAQ) PARM(&NAME &LIB &LENGTH &DATA +
                          &WAIT)
             IF         COND(&DATA = '*END') THEN(GOTO CMDLBL(RELEASE))
/**/
/* Clear the FTP commmand and log file */
/* They have been duplicated in QTEMP as other CL may use */
/* these generic files */
/**/

             CHGVAR     VAR(&ACTION) VALUE('*CLEAR    ')
             CALL       PGM(CGC3703) PARM(&ACTION &RETURN)
             IF         COND(&RETURN *NE ' ') THEN(GOTO +
                          CMDLBL(ABNORMAL))

/**/
/* Call directory explorer, to determine the stream file to be     */
/* transmitted.  If no more entries (*NOFILES return code), end job*/
/**/
             CALL       PGM(CG3630) PARM(&RETURN &STREAM)

             IF         COND(&RETURN = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))

             IF         COND(&RETURN = '*NOFILES') THEN(GOTO +
                          CMDLBL(RELEASE))
/**/
/* Retrieve details for formatting FTP commands */
/**/
             CALL       PGM(CG3612) PARM(&RETURN &STREAM &SRCDIR +
                          &DSTDIR &ACTION &OPTION &USER &PSWRD &HOST)

             IF         COND(&RETURN = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/*/COPY WNCPYSRC,CGH00004                                            */
/**/
/* Format FTP commands */
/**/
             CALL       PGM(CG3628) PARM(&RETURN &SRCDIR &DSTDIR +
                          &ACTION &OPTION &USER &PSWRD)

             IF         COND(&RETURN = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* FTP session */
/**/

             CALL       PGM(CGC3705) PARM(&HOST &RETURN)
             IF         COND(&RETURN = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))

/**/
/* FTP Log Read: CG3629 calls CG3613 (Status of FTP Trans) which     */
/*               will analyse CGFTPLPD log file for error (if any).  */
/*               Use override to use CGFTPLPD in QTEMP.              */
/**/
             CALL       PGM(CG3629) PARM(&RETURN &SRCDIR)

             IF         COND(&RETURN = '*ERROR') THEN(GOTO +
                          CMDLBL(ABNORMAL))

/* Problem with logging in */
             IF         COND(&RETURN = '*LOGINFAIL') THEN(GOTO +
                          CMDLBL(ABNORMAL))

/* Problem with host name */
             IF         COND(&RETURN = '*UNKWNHOST') THEN(GOTO +
                          CMDLBL(ABNORMAL))

/* Problem with path of destination directory */
             IF         COND(&RETURN = '*UNKDSTPTH') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* If FTP XML data transmission completes successfully,      */
/* initiate the FTP FEEDBACK process.                        */
/**/
             CHGVAR     VAR(&RTNPARM) VALUE('          ')
             CHGVAR     VAR(&ACTPARM) VALUE('*START    ')

             CALL       PGM(CGC3701)  PARM(&RTNPARM &ACTPARM)
/**/
             GOTO LOOP

             GOTO RELEASE
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC3607 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/**/                                                                                     /*BUG7700*/
             SNDPGMMSG  MSGID(CGL0001) MSGF(GBCGUSRMSG) +
                          TOMSGQ(MOPERQ MRUNQ)                                           /*BUG7700*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*BUG7700*/
/**/                                                                                     /*BUG7700*/
/* Unlock ICD record, clear data area before ending the job */
/**/
 RELEASE:
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(CGFTP) VALUE(' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             CHGVAR     VAR(&ACTION) VALUE('*DLTOVR   ')
             CALL       PGM(CGC3703) PARM(&ACTION &RETURN)
/* Return Code not trapped here in order to avoid looping */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
