/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CPP for CVTOUTQ command')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       UTC0230 - CPP for CVTOUTQ (Convert output queue)            */
/*                                                                   */
/*      This program is the command-processing program for the       */
/*      CVTOUTQ command.  The command and program were both lifted   */
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
/*       Last Amend No. CPK018  *MOVED     Date 25Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAA002 *CREATE     Date 31OCT95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CAA002 - Development of utility to save, edit and restore   */
/*                spooled files.                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FULLOUTQ &OUTLIB &OUTMBR &REPLACE)
             DCL        VAR(&FULLOUTQ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OUTLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REPLACE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STRPOS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NBRENT) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&ENTLEN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FULLSPC) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SYSNAM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&COUNTA) TYPE(*CHAR) LEN(22)
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
             RTVNETA    SYSNAME(&SYSNAM)
             CHKOBJ     &OUTLIB/OUTQP OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO) /* No file */
                IF         COND(&OUTLIB *EQ '*LIBL') THEN(DO) /* *LIBL +
                             was used */
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('The +
                                OUTLIB cannot be *LIBL if no file +
                                exists') MSGTYPE(*ESCAPE)
                ENDDO      /* *LIBL was used */
                CPYF       FROMFILE(UTCVOQPD) +
                             TOFILE(&OUTLIB/OUTQP) CRTFILE(*YES)
                RNMM       FILE(&OUTLIB/OUTQP) MBR(UTCVOQPD) +
                             NEWMBR(OUTQP)
             ENDDO      /* No file */
             CHKOBJ     OBJ(&OUTLIB/OUTQP) OBJTYPE(*FILE) MBR(&OUTMBR)
             MONMSG     MSGID(CPF9815) EXEC(DO) /* No member */
                ADDPFM     FILE(&OUTLIB/OUTQP) MBR(&OUTMBR)
             ENDDO      /* No member */
             CHGVAR     VAR(&OUTQ) VALUE(%SST(&FULLOUTQ 1 10)) /* +
                          Extract OUTQ */
             CHGVAR     VAR(&OUTQLIB) VALUE(%SST(&FULLOUTQ 11 10)) +
                          /* Extract */
             CHKOBJ     OBJ(&OUTQLIB/&OUTQ) OBJTYPE(*OUTQ)
             IF         COND(&OUTQLIB *EQ '*LIBL') THEN(DO) /* *LIBL +
                          used */
                RTVOBJD    OBJ(&OUTQLIB/&OUTQ) OBJTYPE(*OUTQ) +
                             RTNLIB(&OUTQLIB)
             ENDDO      /* *LIBL used */
             IF         COND(&OUTLIB *EQ '*LIBL') THEN(DO) /* *LIBL +
                          was used */
                RTVOBJD    OBJ(OUTQP) OBJTYPE(*FILE) RTNLIB(&OUTLIB)
             ENDDO      /* *LIBL was used */
             IF         COND(&REPLACE *EQ '*YES') THEN(DO) /* +
                          Replace mbr */
                CLRPFM     FILE(&OUTLIB/OUTQP) MBR(&OUTMBR)
             ENDDO      /* Replace mbr */
             CHGVAR     VAR(&FULLSPC) VALUE('CVTOUTQ   QTEMP')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Converting output queue ' *CAT +
                          &OUTQ *TCAT ' in ' *CAT &OUTQLIB) +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
/* QUSRTOOL command to create a space */
             CRTUSRSPC  USRSPC(QTEMP/CVTOUTQ) DELETE(*YES) +
                          TEXT('Space for CVTOUTQ')
             RMVMSG     CLEAR(*ALL)
/* Use API to fill space */
             CALL       QUSLSPL PARM(&FULLSPC 'SPLF0100' '*ALL' +
                          &FULLOUTQ '*ALL' '*ALL')
                        /* QUSRTOOL command to retrieve inlz values */
             RTVUSRSPCI USRSPC(QTEMP/CVTOUTQ) STRPOS(&STRPOS) +
                          NBRENT(&NBRENT) ENTLEN(&ENTLEN)
             OVRDBF     FILE(UTCVOQPD) TOFILE(&OUTLIB/OUTQP) +
                          MBR(&OUTMBR)
             CALL       PGM(UT0230) PARM(&COUNT &SYSNAM &STRPOS +
                          &NBRENT &ENTLEN &FULLSPC &RTNCDE)
             SNDPGMMSG  MSGID(CPI9801) MSGF(QCPFMSG) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             IF         COND(&RTNCDE *EQ 'NONE') THEN(SNDPGMMSG +
                          MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('There were no spool files to +
                          convert from ' *CAT &OUTQ *TCAT ' in ' +
                          *CAT &OUTQLIB) MSGTYPE(*ESCAPE))
             IF         COND(&RTNCDE *EQ 'GOOD') THEN(DO) /* Good +
                          return */
                EDTVAR     CHROUT(&COUNTA) NUMINP(&COUNT)
                SNDPGMMSG  MSG(&COUNTA *TCAT ' entries converted from +
                             Outq ' *CAT &OUTQ *BCAT 'in' *BCAT +
                             &OUTQLIB *TCAT ' to file OUTQP in ' *CAT +
                             &OUTLIB *TCAT '.') MSGTYPE(*COMP)
                RETURN     /* Good return */
             ENDDO      /* Good return */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Bad +
                          return code of ' *CAT &RTNCDE) +
                          MSGTYPE(*ESCAPE)
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
