/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MECE1025  - Create data queue EEMEIMM                       */
/*                                                                   */
/*       (C) COPYRIGHT MKI LIMITED 1999.                             */
/*                                                                   */
/*       Last Amend No. MD31937            Date 13Jan15              */
/*       Last Amend No. AR856737           Date 13Sep11              */
/*       Last Amend No. ESL038             Date 01Oct2004            */
/*       Prev Amend No. EEE058             Date 05Feb2003            */
/*                      EAH080             Date 17May99              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD31937  - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       ESL038 - ING STP Development                                */
/*       EEE058 - Create data *all                                   */
/*       EAH080 - Generic Incoming Interface                         */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&MKI_CPY_@) TYPE(*CHAR) LEN(80) +
                          VALUE('(C) COPYRIGHT MKI 1999. Company +
                          Confidential.')
/* */
/* Declare variables */
/* */
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(50)
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
/**/
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
             CHGJOB     SWS(XXXXX000)
/**/
/* Check if data queue exists */
/**/
             CHKOBJ     OBJ(&DILIB/EEMEIMM) OBJTYPE(*DTAQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MECE1025 - Create data queue EEMEIMM') +
                          TOMSGQ(MRUNQ)
/**********                                                                            *** EEE058 */
/**********  CRTDTAQ    DTAQ(&DILIB/EEMEIMM) MAXLEN(&FLDLEN) +                         *** EEE058 */
/**********               SEQ(*FIFO) TEXT('ME Data queue for EE +                      *** EEE058 */
/**********               message extraction') AUT(*LIBCRTAUT)                         *** EEE058 */
             CRTDTAQ    DTAQ(&DILIB/EEMEIMM) MAXLEN(&FLDLEN) +
                          SEQ(*FIFO) TEXT('ME Data queue for EE +
                          message extraction') AUT(*ALL)                                /* EEE058 */
             ENDDO
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
             SNDPGMMSG  MSG('Program MECE1025 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MECE1025 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
