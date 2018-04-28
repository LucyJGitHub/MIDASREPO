/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CPP for CRTUSRSPC command')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       UTC0220 - CPP for CRTUSRSPC (Create user space)             */
/*                                                                   */
/*      This program is the command-processing program for the       */
/*      CRTUSRSPC command.  The command and program were both lifted */
/*      from the IBM-supplied QUSRTOOL library of specimen           */
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
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CAA002 *CREATE     Date 31OCT95              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CAA002 - Development of utility to save, edit and restore   */
/*                spooled files.                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FULLSPC &EXTATR &INLSIZE &INLVALUE +
                          &AUT &DELETE &TEXT)
             DCL        VAR(&FULLSPC) TYPE(*CHAR) LEN(20)
             DCL        VAR(&USRSPC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EXTATR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&INLSIZE) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&BIN4) TYPE(*CHAR) LEN(4)
             DCL        VAR(&INLVALUE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&AUT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DELETE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50)
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
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(STDERR1)) /* +
                          Std err */
             CHGVAR     VAR(&USRSPC) VALUE(%SST(&FULLSPC 1 10))
             CHGVAR     VAR(&LIB) VALUE(%SST(&FULLSPC 11 10))
 
/* Change special values to blanks */
             IF         COND(&EXTATR *EQ '*NONE') THEN(CHGVAR +
                          VAR(&EXTATR) VALUE('    '))
             IF         COND(&TEXT *EQ '*BLANK') THEN(CHGVAR +
                          VAR(&TEXT) VALUE('  '))
 
/* Change initial size to binary */
             CHGVAR     VAR(%BIN(&BIN4 1 4)) VALUE(&INLSIZE)
             IF         COND(&DELETE *EQ '*YES') THEN(DO) /* Dlt if +
                          it exists */
                DLTUSRSPC  USRSPC(&LIB/&USRSPC)
                MONMSG     MSGID(CPF2105) EXEC(DO) /* Remove escape */
                   RCVMSG     MSGTYPE(*EXCP) /* Remove not found message */
                ENDDO      /* Remove message */
                RCVMSG     MSGTYPE(*COMP) /* Remove completion message */
             ENDDO      /* Delete if it exists */
 
/* Call OS/400 pgm to create a user space */
             CALL       PGM(QUSCRTUS) PARM(&FULLSPC &EXTATR &BIN4 +
                          &INLVALUE &AUT &TEXT)
             SNDPGMMSG  MSG('User space ' *CAT &USRSPC *TCAT ' +
                          created in library ' *CAT &LIB *TCAT '.') +
                          MSGTYPE(*COMP)
             RMVMSG     CLEAR(*ALL)
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
