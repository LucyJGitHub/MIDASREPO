/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Shuffle data with "program" member')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC3004  - Put *LIFO DTAQ in QTEMP                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Prev Amend No. 183580             Date 22Sep00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 01Jan95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       183580 - Put MONMSG on ADDPFM as in CGC3003                 */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &WORKF &MEMBER &TO_FIRST)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WORKF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TO_FIRST) TYPE(*CHAR) LEN(1)
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
/* Get member description (add member if needed) */
             RTVMBRD    FILE(QTEMP/&WORKF) MBR(&MEMBER)
             MONMSG     MSGID(CPF9815) EXEC(DO)
             ADDPFM     FILE(QTEMP/&WORKF) MBR(&MEMBER)
             MONMSG     MSGID(CPF5812 CPF7306)             /*183580*/
             ENDDO
/* Check direction */
             IF         COND(&TO_FIRST *EQ 'Y') THEN(DO)
             CPYF       FROMFILE(QTEMP/&WORKF) TOFILE(QTEMP/&WORKF) +
                          FROMMBR(&MEMBER) TOMBR(&WORKF) +
                          MBROPT(*REPLACE)
                MONMSG (CPF2800)
             ENDDO
             ELSE       CMD(DO)
             CPYF       FROMFILE(QTEMP/&WORKF) TOFILE(QTEMP/&WORKF) +
                          FROMMBR(&WORKF) TOMBR(&MEMBER) +
                          MBROPT(*REPLACE)
                MONMSG (CPF2800)
             ENDDO
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
             SNDPGMMSG  MSG('Program CGC3004 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC3004 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
 END:        ENDPGM
