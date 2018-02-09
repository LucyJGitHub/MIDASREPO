/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Auto Gen Interactive Watch')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                       */
/*                                                                   */
/*       FTC0330  - FT Auto Generation Interactive Watch             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAAA02             Date 16Jul03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01435             Date 18Oct93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAAA02 - Remove use of INVITE keyword to enable WebFacing   */
/*                to process screens. Recompile only.                */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
             DCL        VAR(&##TMEA) TYPE(*CHAR) LEN(6)
/* */
/* Declare Display file */
/* */
             DCLF       FILE(FTC0330DF)
/* */
/* Global Monitor Message */
/* */
/*           MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)        */
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
             CHGJOB     SWS(XXXXX000)
/**/
/* Check if data queue exists */
/**/
             CALL       PGM(FTC0331)
/* */
/* Set up screen variables */
/* */
             RTVJOBA    JOB(&##JOB) USER(&##USR)
             CHGVAR     VAR(&##PGM) VALUE('FTC0330')
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&##MRDT)
/* */
/* Get option name and function keys */
/* */
             RTVMSG     MSGID(FTM2051) MSGF(FTUSRMSG) MSG(&##ONAM)
             RTVMSG     MSGID(FTM2048) MSGF(FTUSRMSG) MSG(&##TXT1)
             RTVMSG     MSGID(FTM2049) MSGF(FTUSRMSG) MSG(&##CMD2)
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('FTC0330 - FT Auto Gen Interactive +
                          Watch') TOMSGQ(MRUNQ)
/**/
/* Only one user alloweed in at any one time */
/**/
             ALCOBJ     OBJ((MEFTCOMM *DTAQ *EXCLRD)) WAIT(10)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(' ')
             CALL       PGM(MEC1027) PARM(&RTN_CODE 'FTM2047' +
                          'FTUSRMSG ' &MSGDTA '          ' ' ' +
                          'FTC0330' 'N')
             DLYJOB     DLY(10)
             GOTO       CMDLBL(END2)
             ENDDO
/**/
/* Change allocation to shared read */
/**/
             ALCOBJ     OBJ((&DILIB/MEFTCOMM *DTAQ *SHRUPD)) WAIT(0)
             DLCOBJ     OBJ((&DILIB/MEFTCOMM *DTAQ *EXCLRD))
/* */
/* Present FTC0330DF to waiting for action */
/* */
 READSCRN:
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&##TMEA)
             CHGVAR     VAR(&##TME) VALUE(&##TMEA)
             SNDF       RCDFMT(#MSGCTL)
             SNDF       RCDFMT(#CMDTXT2)
             SNDRCVF    RCDFMT(#RCDKEY) WAIT(*NO)
/* */
/* Wait for Input on MEFTCOMM data queue */
/* */
             CALL       PGM(FTC0332) PARM(&RTN_CODE &ACTION)
/* */
/* If return code is read screen  */
/* */
             IF         COND(&ACTION *EQ '*DSPF     ') THEN(DO)
             RCVF       RCDFMT(#RCDKEY)
/* */
/* If F3 then exit else loop and display screen again */
/* */
             IF         COND(&IN03 *EQ '1') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
             ENDDO
/* */
/* If return code is wait next then */
/* */
             IF         COND(&RTN_CODE *NE 'Y2U9999') THEN(DO)
             GOTO       CMDLBL(READSCRN)
             ENDDO
/* */
/* If return code is exit - end */
/* */
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* Delete data queue to show end of watch */
/**/
             ALCOBJ     OBJ((MEFTCOMM *DTAQ *EXCLRD)) WAIT(300)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(END1))
             DLTDTAQ    DTAQ(&DILIB/MEFTCOMM)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&DILIB/MEFTCOMM *DTAQ *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 END1:       DLCOBJ     OBJ((&DILIB/MEFTCOMM *DTAQ *SHRUPD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&DILIB/MEFTCOMM *DTAQ *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program FTC0330 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FTC0330 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* Delete data queue to show end of watch */
/**/
             ALCOBJ     OBJ((MEFTCOMM *DTAQ *EXCLRD)) WAIT(300)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(END2))
             DLTDTAQ    DTAQ(&DILIB/MEFTCOMM)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&DILIB/MEFTCOMM *DTAQ *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 END2:       DLCOBJ     OBJ((&DILIB/MEFTCOMM *DTAQ *SHRUPD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&DILIB/MEFTCOMM *DTAQ *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
