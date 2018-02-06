/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Create data queue CGTELLER')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC0525  - Create data queue CGTELLER                       */
/*                                                                   */
/*  (C) COPYRIGHT FINASTRA INTERNATIONAL LIMITED 1997.               */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCG016 *CREATE     Date 21FEB97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCG016 - Correspondence Manager for Retail Teller System    */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          COPYRIGHT FINASTRA +
                          INTERNATIONAL LIMITED 1997')
/* */
/* Declare variables */
/* */
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&KEY_LEN) TYPE(*DEC) LEN(3 0) VALUE(10)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&MKICPY) VALUE('COPYRIGHT FINASTRA +
                          INTERNATIONAL LIMITED 1997.')
/**/
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
             CHGJOB     SWS(XXXXX000)
/**/
/* Check if data queue exists */
/**/
             CHKOBJ     OBJ(&DILIB/CGTELLER) OBJTYPE(*DTAQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('CGC0525 - Create data queue CGTELLER') +
                          TOMSGQ(MRUNQ)
             CRTDTAQ    DTAQ(&DILIB/CGTELLER) MAXLEN(&FLDLEN) +
                          SEQ(*KEYED) KEYLEN(&KEY_LEN) +
                          SENDERID(*YES) TEXT('CG Data queue for +
                          Print Generator') AUT(*ALL)
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
             DLCOBJ     OBJ((&DILIB/CGTELLER *DTAQ *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC0525 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC0525 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
