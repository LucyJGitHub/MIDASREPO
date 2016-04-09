/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SM populate data to RE ICD files - ctl')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       SMUC00293 - Currency not in Installation control            */
/*                   data files - control pgm                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2014           */
/*                                                                   */
/*       Last Amend No. AR213428 *CREATE   Date 19May14              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR213428 - Utility that will populate data to RECCYD,       */
/*                  RECCYDXC from SDCURRPD if Retail Module is ON.   */
/*                - Applied for MD-26962                             */
/*                                                                   */
/*********************************************************************/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2014')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR2))
 
             CHGJOB     SWS(XXXXXX00)
/**/
/* Update Tables */
/**/
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DPLIB) VALUE(&PRE *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
 
             CPYF       FROMFILE(&DMLIB/RECCYD) +
                          TOFILE(&DPLIB/RECCYDX) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
                MONMSG     MSGID(CPF2863 CPF2817) EXEC(DO)
                   SNDPGMMSG  MSG('File RECCYDX already exists.  +
                                Backup not created.') +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO
 
             CPYF       FROMFILE(&DMLIB/RECCYDXC) +
                          TOFILE(&DPLIB/RECCYDXCX) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
                MONMSG     MSGID(CPF2863 CPF2817) EXEC(DO)
                   SNDPGMMSG  MSG('File RECCYDXCX already exists.  +
                                Backup not created.') +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO
 
             CPYF       FROMFILE(&DMLIB/RECCYZ) +
                          TOFILE(&DPLIB/RECCYZX) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
                MONMSG     MSGID(CPF2863 CPF2817) EXEC(DO)
                   SNDPGMMSG  MSG('File RECCYZX already exists.  +
                                Backup not created.') +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO
 
                CALL       PGM(SMU00293) PARM('U')
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
                DLTF       FILE(&DPLIB/RECCYDX)
                DLTF       FILE(&DPLIB/RECCYDXCX)
                DLTF       FILE(&DPLIB/RECCYZX)
 
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
                CPYF       FROMFILE(&DPLIB/RECCYDX) +
                          TOFILE(&DMLIB/RECCYD) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CPYF       FROMFILE(&DPLIB/RECCYDXCX) +
                          TOFILE(&DMLIB/RECCYDXC) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CPYF       FROMFILE(&DPLIB/RECCYZX) +
                          TOFILE(&DMLIB/RECCYZ) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
 
 ABNOR2:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SMUC00293 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2014')
 
             ENDPGM
