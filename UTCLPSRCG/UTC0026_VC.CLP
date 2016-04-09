/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Validity checker for CMPMSGF')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - UT Module                                           */
/*                                                                   */
/*       UTC0026_VC - Validity checker for CMPMSGF utility           */
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
/*       Prev Amend No. CUP002 *CREATE     Date 08Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CUP002 - Message file utilities                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGFLLIB &MSGF2LIB &OUTPUT &OUTFILE +
                          &MBROPT)
 
             DCL        VAR(&MSGFLLIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&MSGF2LIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OUTPUT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&MBROPT) TYPE(*CHAR) LEN(20)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGF2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTNLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTNLIB2) TYPE(*CHAR) LEN(10)
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
             DCL        VAR(&FTYPE1) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FTYPE2) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(QAFDRFMT)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&MSGF) VALUE(%SST(&MSGFLLIB 1 10))
             CHGVAR     VAR(&LIB) VALUE(%SST(&MSGFLLIB 11 10))
             CHGVAR     VAR(&MSGF2) VALUE(%SST(&MSGF2LIB 1 10))
             CHGVAR     VAR(&LIB2) VALUE(%SST(&MSGF2LIB 11 10))
             CHGVAR     VAR(&OFILE) VALUE(%SST(&OUTFILE 1 10))
             CHGVAR     VAR(&OFLIB) VALUE(%SST(&OUTFILE 11 10))
             CHGVAR     VAR(&MEMBER) VALUE(%SST(&MBROPT 1 10))
             CHGVAR     VAR(&OPTION) VALUE(%SST(&MBROPT 8 10))
 
/* Checking for *BASEMSGF option */
             IF         COND(&MSGF2 *EQ '*BASEMSGF') THEN(DO)
                CHGVAR     VAR(&MSGF2) VALUE(&MSGF)
             ENDDO
 
/* Ascertain nature of parameters - look for absence of '*' in */
/* program parameter to indicate specific requests */
 
/* File1 */
             CALL       PGM(QCLSCAN) PARM(&MSGF &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *EQ 0) THEN(DO)
                CHGVAR     VAR(&FTYPE1) VALUE('NAME')
             ENDDO
             ELSE       CMD(DO)
                IF         COND(&MSGF *EQ '*ALL') THEN(DO)
                   CHGVAR     VAR(&FTYPE1) VALUE('*ALL')
                ENDDO
                ELSE       CMD(DO)
                   CHGVAR     VAR(&FTYPE1) VALUE('*GEN')
                ENDDO
             ENDDO
 
/* File2 */
             CALL       PGM(QCLSCAN) PARM(&MSGF2 &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *EQ 0) THEN(DO)
                CHGVAR     VAR(&FTYPE2) VALUE('NAME')
             ENDDO
             ELSE       CMD(DO)
                IF         COND(&MSGF2 *EQ '*ALL') THEN(DO)
                   CHGVAR     VAR(&FTYPE2) VALUE('*ALL')
                ENDDO
                ELSE       CMD(DO)
                   CHGVAR     VAR(&FTYPE2) VALUE('*GEN')
                ENDDO
             ENDDO
 
/* General tests */
 
/* Use of *ALL with *LIBL not allowed  */
/* Lib1 & lib2 */
             IF         COND(&FTYPE1 *EQ '*ALL' *AND &LIB *EQ +
                          '*LIBL' *OR &FTYPE2 *EQ '*ALL' *AND &LIB2 +
                          *EQ '*LIBL') THEN(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000 +
                          The combination of *ALL and *LIBL is not +
                          allowed.') MSGTYPE(*DIAG)
                CHGVAR VAR(&ERROR) VALUE('Y')
                GOTO CMDLBL(ABNOR)
             ENDDO
 
/* Use of *generic with *LIBL not allowed  */
             IF         COND(&FTYPE1 *EQ '*GEN' *AND &LIB *EQ +
                          '*LIBL' *OR &FTYPE2 *EQ '*GEN' *AND &LIB2 +
                          *EQ '*LIBL') THEN(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000 +
                      The combination of generics and *LIBL is not +
                          allowed.') MSGTYPE(*DIAG)
                CHGVAR VAR(&ERROR) VALUE('Y')
                GOTO CMDLBL(ABNOR)
             ENDDO
 
/* Generic names must be identical */
 
             IF         COND(&FTYPE1 *EQ '*GEN' *OR &FTYPE2 *EQ +
                          '*GEN') THEN(DO)
                IF         COND(&MSGF *NE &MSGF2) THEN(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Generic filenames must be +
                          identical.') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/* If filenames are the same, check that libraries are not*/
             IF         COND(&MSGF *EQ &MSGF2 *AND &LIB *EQ &LIB2) +
                          THEN(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000 +
                          You cannot compare' *BCAT &MSGF *BCAT +
                          'against itself.  Please specify a +
                          different file name or a different +
                          library name.') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Existence Tests */
/* Check libraries exist and user has authority */
/* Lib1 */
             IF         COND(&LIB *NE '*LIBL') THEN(DO)
                CHKOBJ     OBJ(&LIB) OBJTYPE(*LIB) AUT(*USE)
                MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Library' *BCAT &LIB *BCAT +
                          'does not exist or you have +
                          insufficient authority.') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/* Lib2 */
             IF         COND(&LIB2 *NE '*LIBL') THEN(DO)
                CHKOBJ     OBJ(&LIB2) OBJTYPE(*LIB) AUT(*USE)
                MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Library' *BCAT &LIB2 *BCAT +
                          'does not exist or you have +
                          insufficient authority.') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/* Check that specific names exist & authority exists */
 
/* File1 */
             IF         COND(&FTYPE1 *EQ 'NAME') THEN(DO)
                CHKOBJ     OBJ(&LIB/&MSGF) OBJTYPE(*MSGF)
                MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000File' *BCAT &MSGF *BCAT 'not +
                          found in' *BCAT &LIB *BCAT 'or you have +
                          insufficient authority.') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/* File2 */
             IF         COND(&FTYPE2 *EQ 'NAME') THEN(DO)
                CHKOBJ     OBJ(&LIB2/&MSGF2) OBJTYPE(*MSGF)
                MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000File' *BCAT &MSGF2 *BCAT 'not +
                          found in' *BCAT &LIB2 *BCAT 'or you have +
                          insufficient authority.') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                 ENDDO
             ENDDO
 
/* If filenames are the same, and *LIBL is used, check whether */
/* files exist in different libraries */
             IF         COND(&FTYPE1 *EQ 'NAME' *AND &MSGF *EQ +
                          &MSGF2) THEN(DO)
                IF      COND(&LIB *EQ '*LIBL' *OR &LIB2 *EQ '*LIBL') +
                          THEN(DO)
                    RTVOBJD OBJ(&LIB/&MSGF) OBJTYPE(*MSGF) +
                          RTNLIB(&RTNLIB)
                    RTVOBJD OBJ(&LIB2/&MSGF2) OBJTYPE(*MSGF) +
                          RTNLIB(&RTNLIB2)
                   IF    COND(&RTNLIB *EQ &RTNLIB2) THEN(DO)
                      SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000*LIBL is not appropriate.  +
                          The first occurrence of file' *BCAT &MSGF +
                          *BCAT 'is in' *BCAT &RTNLIB *TCAT '. Please +
                          specify a different library.') MSGTYPE(*DIAG)
                      CHGVAR     VAR(&ERROR) VALUE('Y')
                      GOTO       CMDLBL(ABNOR)
                   ENDDO
                ENDDO
             ENDDO
 
/* If outfile chosen then check user has authority to it, if it */
/*   already exists */
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
                         authority.') MSGTYPE(*DIAG)
                      CHGVAR     VAR(&ERROR) VALUE('Y')
                      GOTO       CMDLBL(ABNOR)
                   ENDDO
                ENDDO
 
                CHKOBJ     OBJ(&OFLIB/&OFILE) OBJTYPE(*FILE) AUT(*ALL)
                MONMSG     MSGID(CPF9802) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA('0000User has insufficient +
                               authority to file.') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
/* Check existing file has correct format */
                 OVRDBF     FILE(QAFDRFMT) TOFILE(QTEMP/UTCMPMPD)
 
                 DSPFD      FILE(&OFLIB/&OFILE) TYPE(*RCDFMT) +
                              OUTPUT(*OUTFILE) FILEATR(*PF) +
                              OUTFILE(QTEMP/UTCMPMPD)
                 RCVF
                 IF         COND(&RFNAME *NE 'UTCMPMD0') THEN(DO)
                    SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                              MSGDTA('0000Specified outfile does not +
                             have correct format for CMPMSGF outfile.') +
                              MSGTYPE(*DIAG)
                    CHGVAR     VAR(&ERROR) VALUE('Y')
                    GOTO       CMDLBL(ABNOR)
                 ENDDO
 
              ENDDO
 
 /*  SEND MESSAGE TO CAUSE CPF TO PASS EARLIER MESSAGES BACK         */
  ABNOR:      IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                           MSGID(CPF0002) MSGF(QCPFMSG) +
                           MSGTYPE(*ESCAPE))
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
              ENDPGM
