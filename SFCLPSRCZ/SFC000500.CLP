/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SF Menu Access Audit Log Housekeeping')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Security Profile Facility                           */
/*                                                                   */
/*       SFC000500 - Menu Item Access Audit Log Housekeeping         */
/*                                                                   */
/*       (c) Finastra Systems Technology, Inc. 2023                  */
/*                                                                   */
/*       Last Amend No. CSF014  *CREATE    Date 16Feb23              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSF014 - Menu Item Accesss Audit Log Housekeeping           */
/*                Required to delete audit log records after         */
/*                System Value Retention period has passed.          */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra Systems Technology, Inc. 2023')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('SFC000500 - Menu Item Access Audit +
                          Log Housekeeping') TOMSGQ(MRUNQ)

             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)


             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)

             OVRDBF     FILE(SFAUMNPD) LVLCHK(*NO)

             CALL       PGM(SF000500)

             IF COND(%SWITCH(XXXXXX00)) THEN(DO)
                COMMIT
             ENDDO

/*error*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&JOBTYPE = '0') THEN(DO)
                   SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                                SFC000500 ended abnormally - see job log') +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO

                IF         COND(&JOBTYPE = '1') THEN(DO)
                   SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO

             GOTO       CMDLBL(END)

 ABNOR:

             CHGJOB     SWS(XXXXXX11)

/* Abnormal termination - batch job */

             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             SFC000500 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

/* Abnormal termination - interactive job */

             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra Systems Technology, Inc. 2023')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
