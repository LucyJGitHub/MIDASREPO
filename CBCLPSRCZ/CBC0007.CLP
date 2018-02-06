/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas COB Check lock of object and cancel job')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Module                            */
/*                                                                   */
/*       CBC0007- Lock control and reporting                         */
/*                                                                   */
/*       Function: This program controls locks on specified objects  */
/*                 + Cancel Job if needed                            */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CCB014  *CREATE    Date 25Apr05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB014 - Pre-Scheduled Batch Close Of Business              */
/*                                                                   */
/*********************************************************************/
/* &LIBR: LIBRARY IN WHICH OBJECT TO BE TESTED IS LOCATED            */
/* &FILE: NAME OF  OBJECT TO BE TESTED                               */
/* &OTYP: TYPE OF OBJECT  TO BE TESTED   (BY DEFAULT *FILE)          */
/*        IF TYPE = '*FILE' THEN ALL MEMBER ARE TESTED.              */
/* &TIMEA:DELAY BETWEEN EACH TRIAL (ALPHANUMERIC).                   */
/*        IF &TIMEA = '*IMMED' THEN ALCOBJ WON'T BE PERFORMED        */
/*        CALLING TO LOCKING REPORT PROGRAM WILL BE MADE DIRECTLY    */
/* &NBTRA: NB OF TRIAL ( LEAVE TO BLANK WHEN TIMEA='*IMMED'          */
/* &RETN : RETURN CODE OF PROGRAM: ='        ' IF NO LOCK            */
/*                                 ='*LOCKED ' IF LOCK               */
/*                                 ='*FAILED ' IF A PROBLEM OCCUR    */
/*********************************************************************/
             PGM  PARM(&LIBR &FILE &OTYP &TIMEA &NBTRA &RETN)
/*********************************************************************/
/*                                                                   */
/* API                                                               */
/*                                                                   */
/* RETURN PARAMETERS FOR QUSDLTUS (DELETE USER SPACE)                */
/* RETURN PARAMETERS FOR QUSCRTUS (CREATE USER SPACE)                */
/* RETURN PARAMETERS FOR QUSTRVUS (READ DATA IN USER SPACE)          */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/** COB PARAMETERS */
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OTYP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TIME) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&NBTR) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&TIMEA) TYPE(*CHAR) LEN(6)
             DCL        VAR(&NBTRA) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RETN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
/** USER SPACE PARAMETERS */
             DCL        VAR(&USRSPC) TYPE(*CHAR) LEN(20) +
                          VALUE('CBLCKOBJ  QTEMP     ')
             DCL        VAR(&SIZEUSR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CPT) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&RJOBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RUSRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RJOBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CCB014) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                      Finastra International Limited 2005')
/*********************************************************************/
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/** Check to see if the delay COB Feature is set ON (CCB014) */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CCB014')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR +
                          &SCSARD)
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CCB014) VALUE('Y'))
 
             IF         COND(&CCB014 *NE 'Y') THEN(GOTO ENDCL)
 
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)
             CHGJOB     JOB(&NBR/&USR/&JOB) LOG(4 00 *SECLVL) +
                          LOGCLPGM(*YES) SWS('XXXXXX00')
             CALL       PGM(QUSDLTUS) PARM(&USRSPC ' ')
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%BIN(&SIZEUSR)) VALUE(32567)
             CALL       PGM(QUSCRTUS) PARM(&USRSPC 'CBLCKOBJ  ' +
                          &SIZEUSR ' ' '*USE    ' 'LOCK STATUS +
                          OBJ/FILE')
 
/** CHECK FOR VALIDITY OF PARAMETERS */
/** FILE */
             IF         COND(&OTYP *EQ '       ') THEN(CHGVAR +
                          VAR(&OTYP) VALUE('*FILE  '))
             ELSE       CMD(DO)
             CHKOBJ     OBJ(&LIBR/&FILE) OBJTYPE(&OTYP)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             SNDPGMMSG  MSG('File' *CAT &FILE *CAT ' in library ' +
                          *CAT &LIBR *CAT ' not found.')
             GOTO ABNOR
             ENDDO
             ENDDO
/** TIME */
             IF         COND(&TIMEA *EQ '*IMMED') THEN(GOTO +
                          CMDLBL(LOCK))
             CHGVAR     VAR(&TIME) VALUE(&TIMEA)
             CHGVAR     VAR(&NBTR) VALUE(&NBTRA)
             IF         COND(&TIME *EQ 0) THEN(CHGVAR VAR(&TIME) +
                          VALUE(60))
/** NB OF TRIAL */
             IF         COND(&NBTR *EQ 0) THEN(CHGVAR VAR(&NBTR) +
                          VALUE(5))
/** CREATE USER SPACE FOR LIST OF ACTIVE JOB IN SUBSYSTEM */
 
 
/*********************************************************************/
/*                                                                   */
/*             MAIN LOOP: FILL USR SPC WITH LOCKS ON OBJ/FILE        */
/*                                                                   */
/*********************************************************************/
MAINLOOP:
             CHGVAR     VAR(&CPT) VALUE(0)
LOOP:        ALCOBJ     OBJ((&LIBR/&FILE &OTYP *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002)  EXEC(DO)
             CHGVAR     VAR(&CPT) VALUE(&CPT + 1)
 
             IF         COND(&CPT *LE &NBTR) THEN(DO)
             CALL       PGM(CB0007) PARM(&LIBR &FILE &OTYP &RTN +
                          &RJOBN &RUSRN &RJOBR)
 
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR) SWS(&SWS)
 
             IF         COND((%SST(&SWS 7 1) *EQ '1') *OR (%SST(&SWS +
                          8 1) *EQ '1')) THEN(GOTO CMDLBL(ABNOR))
             IF         COND(&RTN *EQ 'L') THEN(GOTO CMDLBL(NOLOCK))
             SNDPGMMSG  MSG('The job ' *CAT &RJOBN *TCAT '/' *CAT +
                          &RUSRN *TCAT '/' *CAT &RJOBR *TCAT ' is +
                          allocating the object ' *CAT &FILE *CAT +
                          '.') TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
             DLYJOB     DLY(&TIME)
             GOTO       CMDLBL(LOOP)
             ENDDO
             SNDPGMMSG  MSG('The job ' *CAT &RJOBN *TCAT '/' +
                          *CAT &RUSRN *TCAT '/' *CAT &RJOBR *TCAT +
                          ' is CANCELED .') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDJOB     JOB(&RJOBR/&RUSRN/&RJOBN) OPTION(*IMMED)
             ENDDO
NOLOCK:
             DLCOBJ     OBJ((&LIBR/&FILE &OTYP *EXCL))
             CHGVAR     VAR(&RETN) VALUE('          ')
             SNDPGMMSG  MSG('NO Lock on file ' *CAT &FILE *CAT ' in +
                          library ' *CAT &LIBR) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
LOCK:
             CALL       PGM(CB0007) PARM(&LIBR &FILE &OTYP &RTN +
                          &RJOBN &RUSRN &RJOBR)
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR) SWS(&SWS)
             IF         COND((%SST(&SWS 7 1) *EQ '1') *OR (%SST(&SWS +
                          8 1) *EQ '1')) THEN(GOTO CMDLBL(ABNOR))
             IF         COND(&RTN *EQ 'L') THEN(GOTO CMDLBL(NOLOCK))
             SNDPGMMSG  MSG('The job ' *CAT &RJOBN *TCAT '/' *CAT +
                          &RUSRN *TCAT '/' *CAT &RJOBR *TCAT ' is +
                          allocating the object ' *CAT &FILE *CAT +
                          '.') TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDJOB     JOB(&RJOBR/&RUSRN/&RJOBN) OPTION(*IMMED)
             GOTO       CMDLBL(END)
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
             CHGVAR     VAR(&MSG) VALUE('Abnormal Termination of +
                          program LCKCL')
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGVAR     VAR(&RETN) VALUE('*FAILED   ')
 
             GOTO       CMDLBL(END)
 
/**/
/** COMPLETED */
/**/
 
 END:
             CALL       PGM(QUSDLTUS) PARM(&USRSPC ' ')
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&ACTCPY) VALUE('(c) Finastra International +
                          Banking Systems Ltd. 2005')
ENDCL:       ENDPGM
