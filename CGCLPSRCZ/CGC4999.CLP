/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Driver for UDC extract source generator')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC4999  - UDC - Driver for extract generator               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK008             Date 09Jun97              */
/*                      S01522             Date 18Aug95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK008 - DBA R2 packaging:                                  */
/*                - Amend #SRCMBRI to be 112 long.                   */
/*                - Amend #SRCMBRO to be 112 long.                   */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&GROUP_SET &FILE_LIB &MBR_NAME &MBR_TXT)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&GROUP_SET) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE_LIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&MBR_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR_TXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Set switches & remove messages */
/* */
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
/* Check that to file exists */
/* */
             CHGVAR     VAR(&FILE) VALUE(%SST(&FILE_LIB 1 10))
             CHGVAR     VAR(&LIB) VALUE(%SST(&FILE_LIB 11 10))
             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE) AUT(*CHANGE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             RCVMSG     RMV(*NO) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* Ensure QTEMP is at top of library list */
             RMVLIBLE   LIB(QTEMP)
             MONMSG     MSGID(CPF2104)
             ADDLIBLE   LIB(QTEMP)
/* */
/* Clone QTEMP files first */
/* */
             CHKOBJ     OBJ(QTEMP/#SRCMBRI) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CRT))
             CLRPFM     FILE(QTEMP/#SRCMBRI) MBR(*FIRST)
             GOTO       CMDLBL(CHK2)
/*CRT:****** CRTSRCPF   FILE(QTEMP/#SRCMBRI) MBR(*FILE) */            /*CPK008*/
 CRT:                                                                 /*CPK008*/
             CRTSRCPF   FILE(QTEMP/#SRCMBRI) RCDLEN(112) MBR(*FILE)   /*CPK008*/
/* */
 CHK2:       CHKOBJ     OBJ(QTEMP/#SRCMBRO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CRT2))
             CLRPFM     FILE(QTEMP/#SRCMBRO) MBR(*FIRST)
             GOTO       CMDLBL(CALL)
/*CRT2:***** CRTSRCPF   FILE(QTEMP/#SRCMBRO) MBR(*FILE)               /*CPK008*/
 CRT2:                                                                /*CPK008*/
             CRTSRCPF   FILE(QTEMP/#SRCMBRO) RCDLEN(112) MBR(*FILE)   /*CPK008*/
/* */
 CALL:       CALL       PGM(CG4999) PARM(&RTN_CODE &GROUP_SET)
/* */
             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE) +
                          MBR(&MBR_NAME) AUT(*CHANGE)
             MONMSG     MSGID(CPF9815) EXEC(GOTO CMDLBL(CREATE))
/* */
             RMVM       FILE(&LIB/&FILE) MBR(&MBR_NAME)
/* */
CREATE:      ADDPFM     FILE(&LIB/&FILE) MBR(&MBR_NAME) +
                          TEXT(&MBR_TXT) SRCTYPE(RPG)
/* */
             CPYSRCF    FROMFILE(QTEMP/#SRCMBRO) TOFILE(&LIB/&FILE) +
                          FROMMBR(*FIRST) TOMBR(&MBR_NAME) +
                          MBROPT(*REPLACE) SRCOPT(*DATE)
/* */
/* Normal termination */
/* */
             GOTO       CMDLBL(ENDCLPGM)
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
             SNDPGMMSG  MSG('Program CGC4999 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC4999 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
