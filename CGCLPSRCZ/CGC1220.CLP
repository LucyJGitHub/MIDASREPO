/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Override to Archive Files')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC1220  - Override Extract files to Archive Versions       */
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
/*       Prev Amend No. S01522             Date 05Jan95              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Set switches and return code */
/* */
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/* Override Log Files */
/**/
             OVRDBF     FILE(CGUDCLL0) TOFILE(CGXDCLL0)
             OVRDBF     FILE(CGUDCLL1) TOFILE(CGXDCLL1)
/**/
/* Override Reference Files */
/**/
             OVRDBF     FILE(CGUDCRL0) TOFILE(CGXDCRL0)
             OVRDBF     FILE(CGUDCRL1) TOFILE(CGXDCRL1)
             OVRDBF     FILE(CGUDCRL2) TOFILE(CGXDCRL2)
             OVRDBF     FILE(CGUDCRL3) TOFILE(CGXDCRL3)
             OVRDBF     FILE(CGUDCRL4) TOFILE(CGXDCRL4)
             OVRDBF     FILE(CGUDCRL5) TOFILE(CGXDCRL5)
             OVRDBF     FILE(CGUDCRL6) TOFILE(CGXDCRL6)
             OVRDBF     FILE(CGUDCRL7) TOFILE(CGXDCRL7)
/**/
/* Override Data Files */
/**/
             OVRDBF     FILE(CGUDTAL0) TOFILE(CGXDTAL0)
             OVRDBF     FILE(CGUDTAL1) TOFILE(CGXDTAL1)
             OVRDBF     FILE(CGUDTAL2) TOFILE(CGXDTAL2)
/**/
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
             SNDPGMMSG  MSG('Program CGC1220 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC1220 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
/* */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
