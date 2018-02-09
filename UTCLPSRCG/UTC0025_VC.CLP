/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Validity checker for DSPMSGF utility')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - UT Module                                           */
/*                                                                   */
/*       DSPMSGF_VC - Validity checker for DSPMSGF utility           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 25Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP002 *C *CREATE  Date 08Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CUP002 - Message file utilities                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGFLIB &OUTPUT &OUTFILE &MBROPT)
 
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OUTPUT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&MBROPT) TYPE(*CHAR) LEN(20)
             DCL        VAR(&MSGFL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(8)
 
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3) VALUE(1)
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3) VALUE(10)
             DCL        VAR(&PATTERN) TYPE(*CHAR) LEN(10) +
                        VALUE('*')
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(3) VALUE(1)
             DCL        VAR(&TRANSLATE) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3)
             DCL        VAR(&TRIM) TYPE(*DEC) LEN(1)
             DCL        VAR(&WILD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNLIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
 
             DCLF       FILE(QAFDRFMT)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&MSGFL) VALUE(%SST(&MSGFLIB 1 10))
             CHGVAR     VAR(&LIB) VALUE(%SST(&MSGFLIB 11 10))
             CHGVAR     VAR(&OFILE) VALUE(%SST(&OUTFILE 1 10))
             CHGVAR     VAR(&OFLIB) VALUE(%SST(&OUTFILE 11 10))
             CHGVAR     VAR(&MEMBER) VALUE(%SST(&MBROPT 3 10))
             CHGVAR     VAR(&OPTION) VALUE(%SST(&MBROPT 13 8))
 
/* Use of *ALL in *LIBL is not allowed */
             IF         COND(&MSGFL *EQ '*ALL' *AND &LIB *EQ +
                          '*LIBL') THEN(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000The +
                combination of *ALL and *LIBL is not allowed') +
                MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Use of generic in *LIBL is not allowed */
             IF     COND(&LIB *EQ '*LIBL') THEN(DO)
 
/* Look for '*' in program parameter to indicate generic request */
                CALL    PGM(QCLSCAN) PARM(&MSGFL &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
                IF COND(&RESULT *GT 0) THEN(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                       MSGDTA('0000The combination of generics and +
                       *LIBL is not allowed') MSGTYPE(*DIAG)
                       CHGVAR VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/* For single file, check it exists */
/* Look for absence of '*' in program parameter to indicate specific */
/* request */
             CALL       PGM(QCLSCAN) PARM(&MSGFL &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF    COND(&RESULT *EQ 0) THEN(DO)
                CHKOBJ     OBJ(&LIB/&MSGFL) OBJTYPE(*MSGF)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                       MSGDTA('0000File not found') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/* Check library exists and user has authority */
             IF         COND(&LIB *NE '*LIBL') THEN(DO)
                CHKOBJ     OBJ(&LIB) OBJTYPE(*LIB) AUT(*USE)
                MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Library ' *cat &lib *bcat +
                          ' does not exist or you have +
                          insufficient authority') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/* If outfile chosen then check user has authority to it, if it */
/* already exists */
             IF         COND(&OUTPUT *EQ '*OUTFILE') THEN(DO)
 
                IF         COND(&OFILE *EQ ' ') THEN(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                MSGDTA('0000OUTFILE parameter required +
                                for OUTPUT(*OUTFILE)') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
                IF         COND(&OFLIB *NE '*LIBL') THEN(DO)
                   CHKOBJ     OBJ(&OFLIB) OBJTYPE(*LIB) AUT(*USE)
                   MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                      SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Library for outfile does not +
                          exist or you have insufficient +
                          authority') MSGTYPE(*DIAG)
                      CHGVAR     VAR(&ERROR) VALUE('Y')
                      GOTO       CMDLBL(ABNOR)
                   ENDDO
                ENDDO
 
                CHKOBJ     OBJ(&OFLIB/&OFILE) OBJTYPE(*FILE) AUT(*ALL)
                MONMSG     MSGID(CPF9801)
                MONMSG     MSGID(CPF9802) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                MSGDTA('0000User has insufficient +
                                authority to file') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
/* Check existing file has correct format */
                OVRDBF     FILE(QAFDRFMT) TOFILE(QTEMP/UTDSPMPD)
 
                DSPFD      FILE(&OFLIB/&OFILE) TYPE(*RCDFMT) +
                             OUTPUT(*OUTFILE) FILEATR(*PF) +
                             OUTFILE(QTEMP/UTDSPMPD)
                RCVF
                IF         COND(&RFNAME *NE 'UTDSPMD0') THEN(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA('0000Specified outfile does not +
                             have correct format for DSPMSGF outfile') +
                             MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
             ENDDO
 
/*  Send message to cause CPF to pass earlier messages back  */
 ABNOR:      IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                          MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE))
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
