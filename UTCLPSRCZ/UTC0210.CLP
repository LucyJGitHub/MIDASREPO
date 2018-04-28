/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CPP for CPYFRMOUTQ command')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       UTC0210 - CPP for CPYFRMOUTQ                                */
/*                                                                   */
/*      This program is the command-processing program for the       */
/*      CPYFROMOUTQ command.  The command and program were both      */
/*      lifted from the IBM-supplied QUSRTOOL library of specimen    */
/*      utilities.  As such it is not as thoroughly supplied with    */
/*      comments as it might be.                                     */
/*                                                                   */
/*      Note further that the validity checking is carried out in    */
/*      this program, not in a separate validity cheker.             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG19128            Date 06Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CUP008             Date 04Jul00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAA002 *CREATE     Date 31OCT95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG19128 - Spool file number can be 6 long.  Recompile.      */
/*       CUP008 - Change processing for 'NOLINE' option.             */
/*       CAA002 - Development of utility to save, edit and restore   */
/*                spooled files.                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FULLOUTQ &FULLFILE &DLTSPLF)
             DCLF       FILE(UTCVOQPD) /* CVTOUTQ output file */
             DCL        VAR(&FULLOUTQ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FULLFILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DLTSPLF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&COUNT2) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&COUNTA) TYPE(*CHAR) LEN(22)
             DCL        VAR(&COUNTB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TEXT2) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERRORSW) TYPE(*LGL) /* Standard error */
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7) /* Standard +
                          error */
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(512) /* Standard +
                          error */
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(512) /* +
                          Standard error */
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10) /* Standard +
                          error */
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10) /* +
                          Standard error */
             DCL        VAR(&KEYVAR) TYPE(*CHAR) LEN(4) /* Standard +
                          error */
             DCL        VAR(&KEYVAR2) TYPE(*CHAR) LEN(4) /* Standard +
                          error */
             DCL        VAR(&RTNTYPE) TYPE(*CHAR) LEN(2) /* Standard +
                          error */
             DCL        VAR(&RETCODE) TYPE(*CHAR) LEN(10) /* Return +
                          code */
             DCL        VAR(&ERROCC) TYPE(*CHAR) LEN(1) VALUE('N') +
                          /* Error occurred during update of +
                          control record. */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(STDERR1)) /* +
                          Std err */
 
             CHGVAR     VAR(&FILE) VALUE(%SST(&FULLFILE 1 10))
             CHGVAR     VAR(&LIB) VALUE(%SST(&FULLFILE 11 10))
             CHGVAR     VAR(&OUTQ) VALUE(%SST(&FULLOUTQ 1 10))
             CHGVAR     VAR(&OUTQL) VALUE(%SST(&FULLOUTQ 11 10))
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE)
/* Ensure OUTQ exists */
             CHKOBJ     OBJ(&OUTQL/&OUTQ) OBJTYPE(*OUTQ)
                        /* Ensure data base file does not exist */
             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CRTPF))
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('The +
                          file ' *CAT &FILE *TCAT ' in ' *CAT &LIB +
                          *TCAT ' exists. The OUTFILE specified +
                          must be unique') MSGTYPE(*ESCAPE)
 CRTPF:      CHGVAR     VAR(&TEXT) VALUE('Created by CPYFRMOUTQ for +
                          ' *CAT &OUTQL *TCAT '/' *CAT &OUTQ *TCAT +
                          ' on ' *CAT &DATE)
 
/** In order to get the format name correct for the subsequent RPG, +
    file is created in as QTEMP/SPOOLS, renamed and moved. */
             DLTF       FILE(QTEMP/SPOOLS)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(QTEMP/&FILE)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(QTEMP/SPOOLS) RCDLEN(211) MBR(*NONE) +
                          TEXT(&TEXT) MAXMBRS(*NOMAX) SIZE(100000 +
                          10000 10)
             RNMOBJ     OBJ(QTEMP/SPOOLS) OBJTYPE(*FILE) NEWOBJ(&FILE)
             MOVOBJ     OBJ(QTEMP/&FILE) OBJTYPE(*FILE) TOLIB(&LIB)
 
             CVTOUTQ    OUTQ(&OUTQL/&OUTQ) OUTLIB(QTEMP)
/* Get actual library names */
             IF         COND(&OUTQL *EQ '*LIBL') THEN(DO) /* *LIBL */
                RTVOBJD    OBJ(&OUTQL/&OUTQ) OBJTYPE(*OUTQ) RTNLIB(&OUTQL)
             ENDDO      /* Assume a name */
             IF         COND((&LIB *EQ '*LIBL') *OR (&LIB *EQ +
                          '*CURLIB')) THEN(DO) /* Get name */
             RTVOBJD    OBJ(&LIB/&FILE) OBJTYPE(*FILE) RTNLIB(&LIB)
             ENDDO      /* *LIBL */
             OVRDBF     FILE(UTCVOQPD) TOFILE(QTEMP/OUTQP) SECURE(*YES)
             RMVMSG     CLEAR(*ALL)
 READ:                  /* Read from CVTOUTQ file */
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EOF))
/* Bypass files in open status */
             IF         COND(&SPSTS *EQ 'OPN') THEN(GOTO CMDLBL(READ))
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             IF         COND(&COUNT *EQ 10000) THEN(DO) /* Too many */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('You are +
                          trying to convert more than 9999 spooled +
                          files and have reached the internal limit +
                          of CPYFRMOUTQ') MSGTYPE(*ESCAPE)
             ENDDO      /* Too many */
             CHGVAR     VAR(&COUNTB) VALUE(&COUNT)
             CHGVAR     VAR(&MBR) VALUE('MBR' *CAT &COUNTB)
             CHGVAR     VAR(&TEXT) VALUE(&SPFILE *CAT '  ' *CAT +
                          &SPJNAM *TCAT '/' *CAT &SPUSER *TCAT '/' +
                          *CAT &SPJNBR)
             ADDPFM     FILE(&LIB/&FILE) MBR(&MBR) TEXT(&TEXT)
             RCVMSG     MSGTYPE(*COMP)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('CPYSPLF +
                          in operation for spooled file ' *CAT +
                          &SPFILE) TOPGMQ(*EXT) MSGTYPE(*STATUS) /* +
                          Status message */
             CPYSPLF    FILE(&SPFILE) TOFILE(&LIB/&FILE) +
                          JOB(&SPJNBR/&SPUSER/&SPJNAM) +
                          SPLNBR(&SPFNBR) TOMBR(&MBR) CTLCHAR(*FCFC)
                        /* Monitor for SPLF no longer in the system */
                        /*    and the job no longer in the system */
             MONMSG     MSGID(CPF3344) EXEC(DO) /* No spooled file */
             SNDPGMMSG  MSG('Spooled file ' *CAT &SPFILE *TCAT ' +
                          Number ' *CAT &SPFNBR *TCAT ' no longer +
                          exists for job ' *CAT &SPJNBR *TCAT '/' +
                          *CAT &SPUSER *TCAT '/' *CAT &SPJNAM *TCAT +
                          '.') MSGTYPE(*DIAG)
             SNDPGMMSG  MSGID(CPI9801) MSGF(QCPFMSG) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS) /* Blank status msg */
             GOTO       CMDLBL(READ)
             ENDDO      /* No spooled file */
/* Monitor for job no longer in the system */
             MONMSG     MSGID(CPF3342) EXEC(DO) /* No spooled file */
             SNDPGMMSG  MSG('Job ' *CAT &SPJNBR *TCAT '/' *CAT +
                          &SPUSER *TCAT '/' *CAT &SPJNAM *TCAT ' is +
                          no longer in the system. Spooled file ' +
                          *CAT &SPFILE *TCAT ' Number ' *CAT +
                          &SPFNBR *TCAT ' has not been copied.') +
                          MSGTYPE(*DIAG)
             SNDPGMMSG  MSGID(CPI9801) MSGF(QCPFMSG) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS) /* Blank status msg */
             GOTO       CMDLBL(READ)
             ENDDO      /* No spooled file */
/* CPYSPLF worked successfully */
 
/** Call program to create a control record in the newly-created +
/** member. First override to the relevant file and member. */
             OVRDBF     FILE(SPOOLS) TOFILE(&LIB/&FILE) MBR(&MBR)
             CALL       PGM(UT0210) PARM(&RETCODE)
             DLTOVR     FILE(SPOOLS)
 
/** If the return code is 'FILEERR' an error has occurred reading the +
    file.  End abnormally. */
             IF         COND(&RETCODE *EQ 'FILEERR') THEN(GOTO +
                          CMDLBL(STDERR1))
 
/** If the return code is 'NOLINE', no suitable line was found. +
    Report the error and read the next record. */
             IF         COND(&RETCODE *EQ 'NOLINE') THEN(DO)
                CHGVAR     VAR(&ERROCC) VALUE('Y') /* Error has occurred */
                SNDPGMMSG  MSGID(SYS0201) MSGF(UTMSGF) MSGDTA(&MBR +
                             *CAT &FILE *CAT &LIB) MSGTYPE(*DIAG)
                CHGVAR     VAR(&RETCODE) VALUE(' ')                                       /*CUP008*/
                CHGVAR     &COUNT2 (&COUNT2 + 1)                                          /*CUP008*/
                GOTO       CMDLBL(READ)
             ENDDO
 
 
             CHGVAR     &COUNT2 (&COUNT2 + 1)
             SNDPGMMSG  MSGID(CPI9801) MSGF(QCPFMSG) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS) /* Blank status msg */
             IF         (&DLTSPLF *EQ '*YES') DO /* DLTSPLF */
             CHGVAR     &TEXT2 ' Spooled files deleted.'
             DLTSPLF    FILE(&SPFILE) JOB(&SPJNBR/&SPUSER/&SPJNAM) +
                          SPLNBR(&SPFNBR)
             ENDDO      /* DLTSPLF */
             GOTO       READ
 EOF:                   /* All spooled files have been read */
/************RMVMSG     CLEAR(*ALL)              ****/
             EDTVAR     CHROUT(&COUNTA) NUMINP(&COUNT2)
             SNDPGMMSG  MSG(&COUNTA *TCAT ' spooled files +
                          copied to file ' *CAT &FILE *TCAT +
                          ' in ' *CAT &LIB *TCAT ' from output +
                          queue ' *CAT &OUTQ *TCAT ' in ' +
                          *CAT &OUTQL *TCAT '.' *CAT &TEXT2) +
                          MSGTYPE(*COMP)
 
/** If an error occurred when adding a control record, end with an +
    escape message. */
             IF         COND(&ERROCC = 'Y') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('An +
                             error occurred when adding one or more +
                             control records; see previous messages') +
                             MSGTYPE(*ESCAPE)
             ENDDO
 
/** Normal end */
             RETURN     /* Normal end of program */
 STDERR1:               /* Standard error handling routine */
             IF         COND(&ERRORSW) THEN(SNDPGMMSG MSGID(CPF9999) +
                          MSGF(QCPFMSG) MSGTYPE(*ESCAPE))
             CHGVAR     VAR(&ERRORSW) VALUE('1') /* Set to fail on +
                          error */
             RCVMSG     MSGTYPE(*EXCP) RMV(*NO) KEYVAR(&KEYVAR)
 STDERR2:    RCVMSG     MSGTYPE(*PRV) MSGKEY(&KEYVAR) RMV(*NO) +
                          KEYVAR(&KEYVAR2) MSG(&MSG) +
                          MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          RTNTYPE(&RTNTYPE) MSGF(&MSGF) +
                          SNDMSGFLIB(&MSGFLIB)
             IF         COND(&RTNTYPE *NE '02') THEN(GOTO +
                          CMDLBL(STDERR3))
             IF         COND(&MSGID *NE ' ') THEN(SNDPGMMSG +
                          MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG))
             IF         COND(&MSGID *EQ ' ') THEN(SNDPGMMSG +
                          MSG(&MSG) MSGTYPE(*DIAG))
             RMVMSG     MSGKEY(&KEYVAR2)
 STDERR3:    RCVMSG     MSGKEY(&KEYVAR) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) +
                          SNDMSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
