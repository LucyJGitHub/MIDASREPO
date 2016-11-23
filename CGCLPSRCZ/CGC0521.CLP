/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG TELLER Extraction Control')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC0521  - CG PrtGen Control - Retail Teller                */
/*                                                                   */
/*  (C) COPYRIGHT MKI INTERNATIONAL LIMITED 1997.                    */
/*                                                                   */
/*       Last Amend No. CCG016 *CREATE     Date 21FEB97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCG016 - Correspondence Manager for Retail Teller System    */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          COPYRIGHT MKI +
                          INTERNATIONAL LTD. 1997')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&ENDSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG_REF) TYPE(*CHAR) LEN(50)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&MKICPY) VALUE('COPYRIGHT MKI +
                          International Ltd. 1997.')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('CGC0521 - CG PrtGen Control Retail +
                          Teller') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/* */
/* Change date format to YYMMDD */
/* */
             CHGJOB     DATFMT(*YMD)
/* */
/* Call data queue creation and allocation */
/* */
             CALL       PGM(CGC0522) PARM(&RTN_CODE 'Start     ' +
                          &MSG_REF)
/* */
/* Process already active or close down requested */
/* */
             IF         COND(&RTN_CODE *EQ 'CGP1000') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Call data queue creation and allocation get next action */
/* */
             CALL       PGM(CGC0522) PARM(&RTN_CODE 'Next      ' +
                          &MSG_REF)
/* */
/* Start Commitment Control */
/* */
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))
             MONMSG     MSGID(CPF8351)
/* */
/* Loop calling  Print Generator */
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
/* Call CGC0520 - Print Generator */
/* */
             SNDPGMMSG  MSG('Reference ' *CAT &MSG_REF *TCAT ' being +
                          processed.') TOPGMQ(*SAME)
             CHGVAR     VAR(&RTN_CODE) VALUE('       ')
             CALL       PGM(CGC0520) PARM(&RTN_CODE &MSG_REF)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11) *OR +
                             %SWITCH(XXXXXXX1) *OR +
                            ((&RTN_CODE *NE 'CGP1001') *AND +
                             (&RTN_CODE *NE ' '))) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* CGP1001 - Close down requested */
/* */
             IF         COND(&RTN_CODE *EQ 'CGP1001') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Reset switches */
/* */
             CHGJOB     SWS(XXXXXX00)
/* */
/* If count less than 100 then wait for next entry */
/* */
             IF         COND(&COUNT *LE 100) THEN(DO)
/* */
/* Call data queue creation and allocation get next action */
/* */
             CALL       PGM(CGC0522) PARM(&RTN_CODE 'Next      ' +
                          &MSG_REF)
/* */
/* End of process requested */
/* */
             IF         COND(&RTN_CODE *EQ 'CGP1002') THEN(DO)
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
             CALL       PGM(CGC0522) PARM(&RTN_CODE 'Re-submit ' +
                          &MSG_REF)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC0521 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC0521 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
