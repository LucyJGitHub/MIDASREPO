/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Update Tax Related Account Keys')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Utilities Module                                */
/*                                                                   */
/*       UTCMD053762 - Midas UT Update Tax Related Account Keys      */
/*                                                                   */
/*       (c) Finastra International Limited 2019                     */
/*                                                                   */
/*       Last Amend No. MD053762  *CREATE  Date 16Jun19              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD053762 - Tiered Witholding Tax System Values              */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2019')
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(10)

/* Global monitor message                                            */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     SWS(XXXXXX00)

/** Retrieve the system prefix xx   */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
             CHGVAR     VAR(&DPLIB) VALUE(&PRE *TCAT 'DPLIB')

/* Create backup for ACKEYAL */

             CPYF       FROMFILE(&DMLIB/ACKEYAL) TOFILE(&DPLIB/ACKEYALBK) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

/* Create backup for ACKEYAK */

             CPYF       FROMFILE(&DMLIB/ACKEYAK) TOFILE(&DPLIB/ACKEYAKBK) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

/**/

             CLRPFM     FILE(&DPLIB/XACKEYAL)

             CALL       PGM(UTMD53762C)

             CPYF       FROMFILE(&DPLIB/XACKEYAL) TOFILE(&DMLIB/ACKEYAL) +
                          MBROPT(*ADD)

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) TOMSGQ(MOPERQ +
                             MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('UTCMD53762 - Job Terminated, Database +
                             in Error')
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO

             CLRPFM     FILE(&DPLIB/XACKEYAL)

             CALL       PGM(UTMD53762D)

             CPYF       FROMFILE(&DPLIB/XACKEYAL) TOFILE(&DMLIB/ACKEYAL) +
                          MBROPT(*ADD)

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) TOMSGQ(MOPERQ +
                             MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('UTCMD53762 - Job Terminated, Database +
                             in Error')
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO

/*  SEND MESSAGE TO CAUSE CPF TO PASS EARLIER MESSAGES BACK         */

ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          UTCMD53762 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2016')
             ENDPGM
