/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Process SWIFT Files in QGPL')                */
/*********************************************************************/
/*                                                                   */
/*       Midas   - Message Management Module                         */
/*                                                                   */
/*       MEC1461 - ME Process Downloaded SWIFT Files in QGPL         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CFT040  *CREATE    Date 15Sep08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CFT040 - BIC Plus IBAN                                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ERRTYP)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2008')
             DCL        VAR(&ERRTYP) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&INHDR) TYPE(*CHAR) LEN(6) VALUE(*BLANK)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2) VALUE('  ')
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')
             DCL        VAR(&BI) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&IS) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&CT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&YY) TYPE(*DEC) LEN(2 0) VALUE(00)
             DCL        VAR(&MM) TYPE(*DEC) LEN(2 0) VALUE(00)
             DCL        VAR(&DD) TYPE(*DEC) LEN(2 0) VALUE(00)
             DCLF       FILE(METXTFL0)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(END))
             CHGJOB     SWS(00000000)
 
             CHKOBJ     OBJ(MEDWFIPD) OBJTYPE(*FILE) MBR(*FIRST)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('File +
                        MEDWFIPD not found - MEC1461 terminated') +
                        TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ERRTYP) VALUE('6')
             GOTO       CMDLBL(END)
             ENDDO
             CHKOBJ     OBJ(MEDWISPD) OBJTYPE(*FILE) MBR(*FIRST)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('File +
                        MEDWISPD not found - MEC1461 terminated') +
                        TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ERRTYP) VALUE('6')
             GOTO       CMDLBL(END)
             ENDDO
             CHKOBJ     OBJ(MEDWCTPD) OBJTYPE(*FILE) MBR(*FIRST)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('File +
                        MEDWCTPD not found - MEC1461 terminated') +
                        TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ERRTYP) VALUE('6')
             GOTO       CMDLBL(END)
             ENDDO
             CLRPFM     MEDWFIPD
             CLRPFM     MEDWISPD
             CLRPFM     MEDWCTPD
             CLRPFM     METICBPD
             CLRPFM     METICSPD
             CLRPFM     METICCPD
             CLRPFM     METICVPD
             CLRPFM     METXTFPD
             OVRDBF     FILE(MEDWFIPD) TOFILE(MEDWFIPD) LVLCHK(*NO)
             OVRDBF     FILE(MEDWISPD) TOFILE(MEDWISPD) LVLCHK(*NO)
             OVRDBF     FILE(MEDWCTPD) TOFILE(MEDWCTPD) LVLCHK(*NO)
             CRTDTAARA  DTAARA(QTEMP/INHDR) TYPE(*CHAR) LEN(8)
             MONMSG     MSGID(CPF1023)
             CHGDTAARA  DTAARA(INHDR) VALUE(*BLANK)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)
             DSPFD      FILE(QGPL/*ALL) TYPE(*BASATR) +
                        OUTPUT(*OUTFILE) OUTFILE(&DPLIB/METXTFPD)
/* Read METXTFL0 file */
LOOP1:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
             GOTO       CMDLBL(ERROR5)
             ENDDO
/* BI file processing */
             IF         ((&PREF *EQ 'BI') *AND (&BI) *EQ ' ') THEN(DO)
             IF         ((%SST(&ATFILE 3 1) *EQ '_') +
                        *AND (%SST(&ATFILE 10 1) *EQ ' ')) THEN(DO)
             IF         (&INHDR *EQ *BLANK) THEN(DO)
             CHGVAR     VAR(&INHDR) VALUE(%SST(&ATFILE 4 6))
             CHGVAR     VAR(&YY) VALUE(%SST(&INHDR 1 2))
             CHGVAR     VAR(&MM) VALUE(%SST(&INHDR 3 2))
             CHGVAR     VAR(&DD) VALUE(%SST(&INHDR 5 2))
             IF         (&YY *LT 08) THEN(GOTO ERROR1)
             IF         ((&MM *GT 12) *OR (&MM *EQ 00)) +
                        THEN(GOTO ERROR1)
             IF         ((&DD *GT 31) *OR (&DD *EQ 00)) +
                        THEN(GOTO ERROR1)
             CHGDTAARA  DTAARA(INHDR) VALUE('20' *CAT &INHDR)
             CPYF       FROMFILE(&ATFILE) TOFILE(&DPLIB/MEDWFIPD) +
                        MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             GOTO       CMDLBL(ERROR3)
             ENDDO
             CHGVAR     VAR(&BI) VALUE('Y')
             ENDDO
             ELSE       CMD(DO)
             IF         (%SST(&ATFILE 4 6) *EQ &INHDR) THEN(DO)
             CPYF       FROMFILE(&ATFILE) TOFILE(&DPLIB/MEDWFIPD) +
                        MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             GOTO       CMDLBL(ERROR3)
             ENDDO
             CHGVAR     VAR(&BI) VALUE('Y')
             ENDDO
             ENDDO
             ENDDO
             ENDDO
/* IS file processing */
             IF         ((&PREF *EQ 'IS') *AND (&IS) *EQ ' ') THEN(DO)
             IF         ((%SST(&ATFILE 3 1) *EQ '_') +
                        *AND (%SST(&ATFILE 10 1) *EQ ' ')) THEN(DO)
             IF         (&INHDR *EQ *BLANK) THEN(DO)
             CHGVAR     VAR(&INHDR) VALUE(%SST(&ATFILE 4 6))
             CHGVAR     VAR(&YY) VALUE(%SST(&INHDR 1 2))
             CHGVAR     VAR(&MM) VALUE(%SST(&INHDR 3 2))
             CHGVAR     VAR(&DD) VALUE(%SST(&INHDR 5 2))
             IF         (&YY *LT 08) THEN(GOTO ERROR1)
             IF         ((&MM *GT 12) *OR (&MM *EQ 00)) +
                        THEN(GOTO ERROR1)
             IF         ((&DD *GT 31) *OR (&DD *EQ 00)) +
                        THEN(GOTO ERROR1)
             CHGDTAARA  DTAARA(INHDR) VALUE('20' *CAT &INHDR)
             CPYF       FROMFILE(&ATFILE) TOFILE(&DPLIB/MEDWISPD) +
                        MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             GOTO       CMDLBL(ERROR2)
             ENDDO
             CHGVAR     VAR(&IS) VALUE('Y')
             ENDDO
             ELSE       CMD(DO)
             IF         (%SST(&ATFILE 4 6) *EQ &INHDR) THEN(DO)
             CPYF       FROMFILE(&ATFILE) TOFILE(&DPLIB/MEDWISPD) +
                        MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             GOTO       CMDLBL(ERROR2)
             ENDDO
             CHGVAR     VAR(&IS) VALUE('Y')
             ENDDO
             ENDDO
             ENDDO
             ENDDO
/* CT file processing */
             IF         ((&PREF *EQ 'CT') *AND (&CT) *EQ ' ') THEN(DO)
             IF         ((%SST(&ATFILE 3 1) *EQ '_') +
                        *AND (%SST(&ATFILE 10 1) *EQ ' ')) THEN(DO)
             IF         (&INHDR *EQ *BLANK) THEN(DO)
             CHGVAR     VAR(&INHDR) VALUE(%SST(&ATFILE 4 6))
             CHGVAR     VAR(&YY) VALUE(%SST(&INHDR 1 2))
             CHGVAR     VAR(&MM) VALUE(%SST(&INHDR 3 2))
             CHGVAR     VAR(&DD) VALUE(%SST(&INHDR 5 2))
             IF         (&YY *LT 08) THEN(GOTO ERROR1)
             IF         ((&MM *GT 12) *OR (&MM *EQ 00)) +
                        THEN(GOTO ERROR1)
             IF         ((&DD *GT 31) *OR (&DD *EQ 00)) +
                        THEN(GOTO ERROR1)
             CHGDTAARA  DTAARA(INHDR) VALUE('20' *CAT &INHDR)
             CPYF       FROMFILE(&ATFILE) TOFILE(&DPLIB/MEDWCTPD) +
                        MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             GOTO       CMDLBL(ERROR4)
             ENDDO
             CHGVAR     VAR(&CT) VALUE('Y')
             ENDDO
             ELSE       CMD(DO)
             IF         (%SST(&ATFILE 4 6) *EQ &INHDR) THEN(DO)
             CPYF       FROMFILE(&ATFILE) TOFILE(&DPLIB/MEDWCTPD) +
                        MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             GOTO       CMDLBL(ERROR4)
             ENDDO
             CHGVAR     VAR(&CT) VALUE('Y')
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             IF         ((&BI *EQ 'Y') *AND (&IS *EQ 'Y') +
                        *AND (&CT *EQ 'Y')) THEN(GOTO CMDLBL(END))
             GOTO       CMDLBL(LOOP1)
 ERROR1:
             SNDPGMMSG  MSG('Incorrect date format, it must be in YYMMDD.') +
                          TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ERRTYP) VALUE('1')
             GOTO       CMDLBL(END)
 ERROR2:
             SNDPGMMSG  MSG('IBAN Structure file (IS) is empty, you +
                        cannot proceed with the process unless this +
                        file has been populated properly') +
                        TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ERRTYP) VALUE('2')
             GOTO       CMDLBL(END)
 ERROR3:
             SNDPGMMSG  MSG('BIC Plus IBAN file (BI) is empty, you +
                        cannot proceed with the process unless this +
                        file has been populated properly') +
                        TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ERRTYP) VALUE('3')
             GOTO       CMDLBL(END)
 ERROR4:
             SNDPGMMSG  MSG('BIC Countries file (CT) is empty, you +
                        cannot proceed with the process unless this +
                        file has been populated properly') +
                        TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ERRTYP) VALUE('4')
             GOTO       CMDLBL(END)
 ERROR5:
             SNDPGMMSG  MSG('The file being processed is empty. This +
                          may be due to the following reasons  1.) +
                          File sent is not complete BI, IS and CT +
                          files must exist altogether 2.) Error in +
                          filename used during FTP of transfer +
                          process, filename should begin with BI, +
                          IS, or CT') TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ERRTYP) VALUE('5')
             GOTO       CMDLBL(END)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
