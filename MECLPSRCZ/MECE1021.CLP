/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MECE1021  - EE ME IMM Extraction Control - Batch process    */
/*                                                                   */
/*       (C) COPYRIGHT MKI LIMITED 1999.                             */
/*                                                                   */
/*       Last Amend No. MD31937            Date 13Jan15              */
/*       Last Amend No. AR856737           Date 13Sep11              */
/*       Last Amend No. ESL038             Date 01Oct2004            */
/*       Prev Amend No. EAH080             Date 17May99              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD31937  - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       ESL038 - ING STP Development                                */
/*       EAH080 - Generic Incoming Interface                         */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&MKI_CPY_@) TYPE(*CHAR) LEN(80) +
                          VALUE('(C) COPYRIGHT MKI +
                          International 1999. Company Confidential.')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&ENDSTS) TYPE(*CHAR) LEN(1)
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
             SNDPGMMSG  MSG('MECE1021 - EE ME IMM Control') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
/* */
/* Call data queue creation and allocation */
/* */
             CALL       PGM(MECE1022) PARM(&RTN_CODE 'Start     ')
/* */
/* Process already active or close down requested */
/* */
             IF         COND(&RTN_CODE *EQ 'MIN0123') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Start Commitment Control */
/* */
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))
             MONMSG     MSGID(CPF8351)
/* */
/* Loop calling  MS Extraction process */
/* */
 LOOP:
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
/* */
/* Check for Cancellation of process - look at end status */
/* */
             RTVJOBA    ENDSTS(&ENDSTS)
             IF         COND(&ENDSTS *EQ '1') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Run INCMSGR - Incoming Message Extract */
/* */
             CHGJOB     DATFMT(*YMD)
/* */
             CALL       PGM(INCMSGR) PARM(&RTN_CODE)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11) *OR +
                             %SWITCH(XXXXXXX1) *OR +
                             (&RTN_CODE *NE ' ')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* Reset switches */
/* */
             CHGJOB     SWS(XXXXXX00)
/* */
/* If count less than 10 then wait for next entry */
/* */
             IF         COND(&COUNT *LE 1000) THEN(DO)
/* */
/* Call data queue creation and allocation get next action */
/* */
             CALL       PGM(MECE1022) PARM(&RTN_CODE 'Next      ')
/* */
/* End of process requested */
/* */
             IF         COND(&RTN_CODE *EQ 'MIN0128') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Re-run process */
/* */
             GOTO       CMDLBL(LOOP)
/* */
             ENDDO
             ELSE       CMD(DO)
/* */
/* Check for Cancellation of process - look at end status */
/* */
             RTVJOBA    ENDSTS(&ENDSTS)
             IF         COND(&ENDSTS *EQ '1') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Call data queue creation and allocation to end process */
/* */
             CALL       PGM(MECE1022) PARM(&RTN_CODE 'Re-submit ')
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
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MECE1021 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MECE1021 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
