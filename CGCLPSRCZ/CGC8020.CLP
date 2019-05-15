/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Create list of layout paths.')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC8020  - Traverse Structure Calling Work Program          */
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
/*       Prev Amend No. S01522             Date 01Jan95              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &ACTION_CDE &FROM_PLANE &PATH)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FROM_PLANE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TO_PLANES) TYPE(*CHAR) LEN(1000)
             DCL        VAR(&ENTRY) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&START_POS) TYPE(*DEC) LEN(5 0) VALUE(1)
             DCL        VAR(&PATH) TYPE(*CHAR) LEN(376)
             DCL        VAR(&PATH2) TYPE(*CHAR) LEN(376)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ACTION_CDE) TYPE(*CHAR) LEN(8)
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
/* Ensure that from group is not in path. */
/* */
             CALL       PGM(CG8210) PARM(&RTN_CODE &FROM_PLANE &PATH)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* Change path to include from group */
/* */
             CHGVAR     VAR(&PATH) VALUE(&PATH *TCAT '\' *TCAT +
                          &FROM_PLANE)
/* */
/* Get list of associated groups */
/* */
             CALL       PGM(CG8070) PARM(&RTN_CODE '*LIST   ' +
                          &FROM_PLANE &ENTRY &TO_PLANES &PATH)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* If return code is no associated groups write path */
/* */
             IF         COND(&RTN_CODE *EQ 'CGD1547') THEN(DO)
/* */
/* Perform Work (Output Path, QTEMP RDE data...) */
/* */
             CALL       PGM(CG8070) PARM(&RTN_CODE &ACTION_CDE +
                          &FROM_PLANE &ENTRY &TO_PLANES &PATH)
/* */
             SNDPGMMSG  MSGID(CGD1086) MSGF(CGUSRMSG) MSGDTA(&PATH)
/* */
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Loop through to_groups list and call CGC1020 */
/* */
LOOP:
             CHGVAR     VAR(&FROM_PLANE) VALUE(%SST(&TO_PLANES +
                          &START_POS 10))
             CHGVAR     VAR(&START_POS) VALUE(&START_POS + 10)
             CHGVAR     VAR(&ENTRY) VALUE(&ENTRY -1)
             CHGVAR     VAR(&PATH2) VALUE(&PATH)
/* */
             IF         COND(&FROM_PLANE *NE '      ') THEN(DO)
             CALL       PGM(CGC8020) PARM(&RTN_CODE &ACTION_CDE +
                          &FROM_PLANE &PATH2)
             ENDDO
/* */
             IF         COND(&ENTRY *GT 0) THEN(GOTO CMDLBL(LOOP))
/* */
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC8020 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC8020 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
