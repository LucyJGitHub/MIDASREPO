/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME IMM extraction control')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Message Management Module                       */
/*                                                                   */
/*       MEC1021  - MS ME IMM Extraction Control - Batch process     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK016             Date 04Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CFT002             Date 20Nov98              */
/*                      S01435             DATE 19AUG93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       CFT002 - Straight Through Processing Phase 1                */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&ENDSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MEC1021 - MS ME IMM Control') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
/* */
/* Call data queue creation and allocation */
/* */
             CALL       PGM(MEC1022) PARM(&RTN_CODE 'Start     ')
/* */
/* Process already active or close down requested */
/* */
             IF         COND(&RTN_CODE *EQ 'MIN0123') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Start Commitment Control */
/* */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))   **/                          /*CFT002*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) + */                /*CFT002*/ /*CPK016*/
/**********               CMTSCOPE(*JOB)                     */                /*CFT002*/ /*CPK016*/
/**********  MONMSG     MSGID(CPF8351) */                                                 /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
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
/* Run MSC1900 - S.W.I.F.T. Extraction */
/* */
             CALL       PGM(MSC1900) PARM(&RTN_CODE)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11) *OR +
                             %SWITCH(XXXXXXX1) *OR +
                             (&RTN_CODE *NE ' ')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/*/COPY WNCPYSRC,MEC1021001                                          */
/* */
/* Reset switches */
/* */
             CHGJOB     SWS(XXXXXX00)
/*/COPY WNCPYSRC,MEC1021002                                          */
/* */
/* If count less than 10 then wait for next entry */
/* */
             IF         COND(&COUNT *LE 1000) THEN(DO)
/* */
/* Call data queue creation and allocation get next action */
/* */
             CALL       PGM(MEC1022) PARM(&RTN_CODE 'Next      ')
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
             CALL       PGM(MEC1022) PARM(&RTN_CODE 'Re-submit ')
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
             SNDPGMMSG  MSG('Program MEC1021 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1021 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
