/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME IMM Extraction job')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MECE1024 - Send Prompt to EE ME IMM Extraction Job          */
/*                                                                   */
/*       (C) COPYRIGHT MKI LIMITED 1999.                             */
/*                                                                   */
/*       Last Amend No. MD031937           Date 13Jan15              */
/*       Prev Amend No. AR856737           Date 13Sep11              */
/*                      ESL038             Date 01Oct2004            */
/*                      EAH080   *CREATE   Date 17May99              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD031937 - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       ESL038 - ING STP Development                                */
/*       EAH080 - Generic Incoming Interface                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&MKI_CPY_@) TYPE(*CHAR) LEN(80) +
                          VALUE('(C) COPYRIGHT MKI 1999. Company +
                          Confidential.')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&MKI_CPY_@) VALUE('(C) COPYRIGHT MKI Ltd +
                          1999.')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MECE1024 - Send Prompt to EE ME IMM +
                          Extraction Control') TOMSGQ(MRUNQ)
/**/
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/* Check if data queue exists */
/**/
             CALL       PGM(MECE1025)
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
             ALCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(SEND)
             ENDDO
/**/
/* Start process */
/**/
             CALL       PGM(MECE1023) PARM(&RTN_CODE)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'MIN0123')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
/* Deallocate */
/**/
             DLCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *EXCL))
/**/
/* Send data queue entry to prompt process */
/**/
 SEND:       CHGVAR     VAR(&DATA) VALUE(' ')
             CHGVAR     VAR(&DATA) VALUE('Prompt')
             CALL       PGM(QSNDDTAQ) PARM('EEMEIMM' &DILIB +
                          &FLDLEN &DATA)
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MECE1024 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MECE1024 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             ENDPGM
