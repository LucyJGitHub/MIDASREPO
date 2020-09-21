/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Automatic Account Closure Control')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       XXC0083 - Automatic Account Closure Control                 */
/*                                                                   */
/*       (c) Finastra International Systems Ltd. 2020                */
/*                                                                   */
/*       Last Amend No. FVT106  *CREATE    Date 14Sep20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       FVT106 - Automatic Account Closure & Account re-opening     */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT)

/* Declare variables */

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Systems Ltd. 2020')
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(52)
             DCL        VAR(&PRESBS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)

             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' '))

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Reset Switches */

             CHGJOB     SWS(00000000)

             SNDPGMMSG  MSG('XXC0083 - Automatic Account Closure Ctl') +
                          TOMSGQ(MRUNQ)

/* Retrieve SDSTAT and set &DMLIB variable */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRESBS)
             CHGVAR     VAR(&DMLIB) VALUE(&PRESBS *TCAT 'DMLIB')

/* Override to SEQONLY(*YES 100) */

             OVRDBF     FILE(ACCNTAB) SEQONLY(*YES 100)
             OVRDBF     FILE(ACCNTAC) SEQONLY(*YES 100)
             OVRDBF     FILE(ACORDAB) SEQONLY(*YES 100)
             OVRDBF     FILE(ACORDAC) SEQONLY(*YES 100)

/* Call CB0160 to check status of component, if restart, cpyf saved versions  */
/* of files to original files */

             CALL       CB0160 PARM(&CNAM &CSEQ &STATUS)

             IF         COND(&STATUS = 'Y') THEN(DO)

             CPYF       FROMFILE(ACORDAB) TOFILE(ACCNTAB) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ACCNTAB))

             CPYF       FROMFILE(ACORDAC) TOFILE(ACCNTAC) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ACCNTAC))
             CPYF       FROMFILE(ACORDAC) TOFILE(ACCNTAC) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)

             ENDDO

/* Else, if not restart, clear copy files ... */

             ELSE CMD(DO)

             CLRPFM     FILE(ACORDAB)
             CLRPFM     FILE(ACORDAC)

/* Then create Security Copies of files */

             CPYF       FROMFILE(ACCNTAB) TOFILE(ACORDAB) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)

             CPYF       FROMFILE(ACCNTAC) TOFILE(ACORDAC) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)

             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
             ENDDO

             DLTOVR     FILE(ACORDAB ACORDAC)
             DLTOVR     FILE(ACCNTAB ACCNTAC)

/* Call XX0083 Automatic Account Closure */

             CALL       PGM(XX0083) PARM(&RSEQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                        GOTO END
             ENDDO


/* XX0083 Database error processing */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGVAR     VAR(&MEM) VALUE('XXC0083 - JOB TERMINATED, DATABASE IN +
                             ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO

/* Change component status ...*/

             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)

/* Then clear Security Copy */
             CLRPFM     FILE(ACORDAB)
             CLRPFM     FILE(ACORDAC)

             RCLRSC
             GOTO       CMDLBL(END)

 ABNOR:
             CHGJOB     SWS(XXXXXX11)

/* Abnormal termination - batch job */

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXC0083 ended +
                          abnormally - see job log') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('Copyright Finastra International +
                          Systems Ltd. 2020')

             ENDPGM
