/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Job status retrieval for CM FTP')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC3603  -  Job Status Retrieval for Correspondence         */
/*                   Manager FTP                                     */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CCG015  *CREATE    Date 08Nov01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTNCODE)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
/**/
/* Declare variables */
/**/
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&BUSY)    TYPE(*CHAR) LEN(1)
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/* Set job switches */
/**/
             CHGJOB     SWS(XXXXX000)
/**/
/* Check if dtaara CGFTP exists, if not, it means that the CM ICD */
/* is maintained for the FIRST TIME. Hence allow entry to ICD     */
/* maintenance screen as it will be created by the ICD setup pgm. */
/* NOTE: DO NOT PERFORM OBJECT ALLOCATION, EXIT PROGRAM.          */
/**/
             CHKOBJ     OBJ(CGFTP) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(ENDCLPGM))
/**/
/* Retrieve FTP job status from CGFTP. Value = 'Y' means that */
/* FTP job is currently running so send '*BUSY' return code.  */
/**/
             RTVDTAARA  DTAARA(CGFTP (1 1)) RTNVAR(&BUSY)
             IF         COND(&BUSY *EQ 'Y') THEN(CHGVAR VAR(&RTNCODE) +
                           VALUE('*BUSY  '))
/**/
/* Terminate the program */
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             CHGVAR     VAR(&RTNCODE) VALUE('*ERROR ')
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC3603 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */
             ENDPGM
