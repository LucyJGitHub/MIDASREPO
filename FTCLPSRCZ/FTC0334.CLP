/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Send Information to MEFTCOMM')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                           */
/*                                                                   */
/*       FTC0333  - Send Information to MEFTCOMM                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01435             Date 18Oct93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &ACTION &MSG_REF &MSG_PART +
                          &S1DATA &S4DATA)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(1536)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(1536)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG_REF) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG_PART) TYPE(*CHAR) LEN(3)
             DCL        VAR(&S1DATA) TYPE(*CHAR) LEN(512)
/**********  DCL        VAR(&S4DATA) TYPE(*CHAR) LEN(512) */                              /*CGL029*/
             DCL        VAR(&S4DATA) TYPE(*CHAR) LEN(540)                                 /*CGL029*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
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
/*           Check if data queue exists - if not exit                */
/**/
             CHKOBJ     OBJ(&DILIB/MEFTCOMM) OBJTYPE(*DTAQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Allocate data queue before use */
/**/
             ALCOBJ     OBJ((&DILIB/MEFTCOMM *DTAQ *SHRUPD))
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/*           Send data to Interactive process                       */
/**/
             CHGVAR     VAR(&DATA) VALUE(&RTN_CODE *CAT &ACTION *CAT +
                          &MSG_REF *CAT &MSG_PART *CAT &S1DATA *CAT +
                          &S4DATA)
/**/
             CALL       PGM(QSNDDTAQ) PARM('MEFTCOMM' &DILIB +
                          &FLDLEN &DATA)
/**/
/*           Allow interactive job to pick up message                */
/**/
             DLYJOB     DLY(5)
/**/
/*           Wait for reply                                          */
/**/
             CHGVAR     VAR(&WAIT) VALUE(-1)
             CALL       PGM(QRCVDTAQ) PARM('MEFTCOMM' &DILIB &FLDLEN +
                          &DATA &WAIT)
/**/
/*           If return code is *CHANGE then reset data               */
/**/
             IF         COND(%SST(&DATA 1 7) *EQ 'FTM2050') THEN(DO)
             CHGVAR     VAR(&ACTION) VALUE(%SST(&DATA 8 8))
             CHGVAR     VAR(&S1DATA) VALUE(%SST(&DATA 27 512))
             CHGVAR     VAR(&S4DATA) VALUE(%SST(&DATA 539 512))
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
             DLCOBJ     OBJ((&DILIB/MEFTCOMM *DTAQ *SHRUPD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program FTC0332 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FTC0332 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             DLCOBJ     OBJ((&DILIB/MEFTCOMM *DTAQ *SHRUPD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
