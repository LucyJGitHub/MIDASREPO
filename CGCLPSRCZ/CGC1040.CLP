/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Group Set Definition Maint/Enquiry')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC1040  - Group Set Definition Maintenance/Enquiry         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01522             DATE 21NOV94              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &ACTION &KEY_INFO)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEY_INFO) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&GRP_SET_C) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Check if maintenance is allowed */
/* */
             RTVDTAARA  DTAARA(CGDTA (35 1)) RTNVAR(&GRP_SET_C)
             IF         COND((&GRP_SET_C *NE 'N') *AND (&ACTION *EQ +
                          'A')) THEN(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(' ')
             CALL       PGM(CGC0380) PARM(&RTN_CODE 'CGD1469' +
                          'CGUSRMSG ' &MSGDTA 'ENTER     ' ' ' +
                          'CGC1040' 'Y')
/**/
/* Exit program if not in Group set set up mode */
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
             ENDDO
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('CGC1040 - CG Group Set Definition') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
/* */
/* Run CG1040 - Group Set Definition */
/* */
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
             CALL       PGM(CG1040) PARM(&RTN_CODE &ACTION &KEY_INFO)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
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
             SNDPGMMSG  MSG('Program CGC1040 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC1040 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
/* */
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
