/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AO CL to retrieve job status')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Access Objects Module                               */
/*                                                                   */
/*       RTVJOBST - RETRIEVE JOB STATUS                              */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG2686  *CREATE   Date 31May04              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG2686 - Retrieve job status.                              */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&JOB  &RTNJOBW &RTNUSRW &RTNNUMW &RTNJIDW +
                          &RTNSTSW)
 
/* Declare PGM Variables */
 
             DCL        VAR(&CpyFld)     TYPE(*CHAR) LEN(64) VALUE('(c) +
                               Finastra International Limited +
                               2004')
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(26)
             DCL        VAR(&RTVJI) TYPE(*CHAR) LEN(111)
             DCL        VAR(&RTNJOBW) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTNUSRW) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTNNUMW) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTNJIDW) TYPE(*CHAR) LEN(16)
             DCL        VAR(&RTNSTSW) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LENDTA) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FMTNA) TYPE(*CHAR) LEN(8)
             DCL        VAR(&INTJOB) TYPE(*CHAR) LEN(16) VALUE(' ')
 
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(16)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
 
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */
/*       Check job status.                                           */
/* */
             CHGVAR     %BIN(&LENDTA 1 4) 111
             CHGVAR     %BIN(&ERROR  1 4) 16
             CHGVAR     &FMTNA 'JOBI0200'
 
             CALL QUSRJOBI PARM(&RTVJI &LENDTA &FMTNA &JOB &INTJOB &ERROR)
 
             CHGVAR &RTNJOBW VALUE(%SST(&RTVJI 9 10))
             MONMSG     MSGID(MCH3601)
             CHGVAR &RTNUSRW VALUE(%SST(&RTVJI 18 10))
             MONMSG     MSGID(MCH3601)
             CHGVAR &RTNNUMW VALUE(%SST(&RTVJI 29 6))
             MONMSG     MSGID(MCH3601)
             CHGVAR &RTNJIDW VALUE(%SST(&RTVJI 35 16))
             MONMSG     MSGID(MCH3601)
             CHGVAR &RTNSTSW VALUE(%SST(&RTVJI 51 10))
             MONMSG     MSGID(MCH3601)
 
             RETURN
 
             GOTO       CMDLBL(END)
 
/* */
 ABNOR:      SNDPGMMSG  MSG('AOC8002 - Ended Abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&RTNCDE) VALUE('*ERROR*')
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
 END:
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
             ENDPGM
