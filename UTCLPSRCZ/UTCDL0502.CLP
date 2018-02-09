/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UT Check corrupted FSRRAT in historic - ctl')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       UTCDL0502 - Check duplicate deals in historic - control pgm */
/*                                                                   */
/*       (c) Finastra International Limited 2012                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR317892 *CREATE   Date 26Jul12              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR317892 - Utility that will check corrupted FSRRAT fields  */
/*                  in DLBHISPD, DLCHISPD and DLDHISPD.              */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&PMODE)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2012')
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             IF         COND((&PMODE *NE 'A') *AND (&PMODE *NE +
                          'a') *AND (&PMODE *NE 'U') +
                          *AND (&PMODE *NE 'u')) THEN(DO)
                SNDPGMMSG  MSG('Valid parameter: ''A'' for Audit mode +
                          or ''U'' for Update mode.')
                GOTO       CMDLBL(END)
             ENDDO
 
             CHGJOB     SWS(XXXXXX00)
 
/* Audit mode */
 
             IF         COND((&PMODE *EQ 'A') *OR (&PMODE *EQ 'a')) +
                          THEN(DO)
 
                CALL       PGM(UTDL0502) PARM('A')
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             ENDDO
 
/* Update mode */
 
             IF         COND((&PMODE *EQ 'U') *OR (&PMODE *EQ 'u')) +
                          THEN(DO)
 
                RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
                CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
                CHGVAR     VAR(&DPLIB) VALUE(&PRE *TCAT 'DPLIB')
                CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
 
                CPYF       FROMFILE(&DMLIB/DLBHISPD) +
                          TOFILE(&DPLIB/DLBHISPDX) CRTFILE(*YES)
                MONMSG     MSGID(CPF2863 CPF2817) EXEC(DO)
                   SNDPGMMSG  MSG('File DLBHISPDX already exists.  +
                                Backup not created.') +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO
 
                CPYF       FROMFILE(&DMLIB/DLCHISPD) +
                          TOFILE(&DPLIB/DLCHISPDX) CRTFILE(*YES)
                MONMSG     MSGID(CPF2863 CPF2817) EXEC(DO)
                   SNDPGMMSG  MSG('File DLCHISPDX already exists.  +
                                Backup not created.') +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO
 
                CPYF       FROMFILE(&DMLIB/DLDHISPD) +
                          TOFILE(&DPLIB/DLDHISPDX) CRTFILE(*YES)
                MONMSG     MSGID(CPF2863 CPF2817) EXEC(DO)
                   SNDPGMMSG  MSG('File DLDHISPDX already exists.  +
                                Backup not created.') +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO
 
                CALL       PGM(UTDL0502) PARM('U')
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
                DLTF       FILE(&DPLIB/DLBHISPDX)
                DLTF       FILE(&DPLIB/DLCHISPDX)
                DLTF       FILE(&DPLIB/DLDHISPDX)
 
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          UTCDL0502 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND((&PMODE *EQ 'U') *OR (&PMODE *EQ 'u')) +
                          THEN(DO)
 
                CPYF       FROMFILE(&DPLIB/DLBHISPDX) +
                          TOFILE(&DMLIB/DLBHISPD) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CPYF       FROMFILE(&DPLIB/DLCHISPDX) +
                          TOFILE(&DMLIB/DLCHISPD) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CPYF       FROMFILE(&DPLIB/DLDHISPDX) +
                          TOFILE(&DMLIB/DLDHISPD) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDDO
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Banking Systems Ltd. 2012')
 
             ENDPGM
